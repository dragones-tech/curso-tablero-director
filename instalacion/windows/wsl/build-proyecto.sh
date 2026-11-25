#!/usr/bin/env bash
# Se ejecuta como el usuario normal dentro de Ubuntu (WSL).
# Uso: build-proyecto.sh <ruta_origen_del_proyecto> <ruta_archivos_alumnos>
set -euo pipefail

ORIGEN="${1:?Falta la ruta del proyecto}"
ALUMNOS="${2:?Falta la ruta de los archivos de los alumnos}"
DESTINO="$HOME/proyecto-python"

# Se copia al sistema de archivos de Linux: /mnt/c es MUY lento para Docker.
if [ -d "$DESTINO" ]; then
  echo ">> $DESTINO ya existe, no se sobrescribe."
else
  cp -r "$ORIGEN" "$DESTINO"
  # Normalizar finales de linea por si vienen de Windows
  find "$DESTINO" -type f \( -name "*.py" -o -name "*.txt" -o -name "*.yml" -o -name "*.md" \
    -o -name "Dockerfile" -o -name ".gitignore" \) -exec sed -i 's/\r$//' {} +
  echo ">> Proyecto copiado a $DESTINO"
fi

# Archivos de ejemplo del curso: solo se copian si la carpeta aun esta vacia,
# para no pisar nada si se vuelve a ejecutar la instalacion.
mkdir -p "$DESTINO/archivos_ejemplo"
if [ -z "$(ls -A "$DESTINO/archivos_ejemplo" | grep -v '^.gitkeep$' || true)" ]; then
  cp -r "$ALUMNOS"/. "$DESTINO/archivos_ejemplo/"
  echo ">> Archivos de ejemplo copiados a $DESTINO/archivos_ejemplo"
else
  echo ">> $DESTINO/archivos_ejemplo ya tiene archivos, no se sobrescriben."
fi

# Repositorio Git para guardar cada paso que funcione
cd "$DESTINO"
if [ ! -d .git ]; then
  git init -q -b main
  # Nombre local del repositorio; se puede cambiar al conectar con GitHub
  git config user.name  >/dev/null || git config user.name  "$USER"
  git config user.email >/dev/null || git config user.email "$USER@curso.local"
  git add -A
  git commit -q -m "Punto de partida del curso"
  echo ">> Repositorio Git creado."
fi

# Esperar a que el servicio docker este arriba
for i in $(seq 1 20); do
  docker info >/dev/null 2>&1 && break
  sleep 1
done

docker compose up -d --build

echo ">> Comprobando http://localhost:8000 ..."
for i in $(seq 1 30); do
  if curl -fsS http://localhost:8000 >/dev/null 2>&1; then
    echo ">> La aplicacion responde en http://localhost:8000"
    exit 0
  fi
  sleep 1
done

echo ">> ERROR: la aplicacion no respondio. Detalle:"
docker compose logs --tail 40 app
exit 1
