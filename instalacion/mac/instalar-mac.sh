#!/bin/bash
# Instalacion del curso en macOS 13 (Ventura) o mas reciente, Apple Silicon (M) o Intel.
# No necesita Homebrew ni contrasena de administrador.
#
# Uso (en la app Terminal, una sola linea):
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/dragones-tech/curso-tablero-director/main/instalacion/mac/instalar-mac.sh)"
# Asi se descarga solo: baja los materiales del curso a ~/curso-tablero-director
# y sigue desde ahi. Si ya tienes la carpeta del curso, tambien sirve:
#   bash <carpeta del curso>/instalacion/mac/instalar-mac.sh
#
# Instala: Command Line Tools de Apple (trae Git), Rancher Desktop (Docker Engine
# de Linux, gratuito), Claude Code y herdr. Despues copia el proyecto a
# ~/proyecto-python y arranca la aplicacion en http://localhost:8000.
# Se puede ejecutar varias veces: lo que ya esta instalado no se repite.
#
# Compatible con el bash 3.2 que trae macOS.
set -euo pipefail

paso()  { printf '\n\033[1;36m>> %s\033[0m\n' "$*"; }
aviso() { printf '\033[1;33m>> AVISO: %s\033[0m\n' "$*"; }
error() { printf '\n\033[1;31m>> ERROR: %s\033[0m\n' "$*"; exit 1; }

[ "$(uname)" = "Darwin" ] || error "Este script es solo para Mac."

# ---------------------------------------------------------------------------
# Materiales del curso: si este script no esta dentro de la carpeta del curso
# (por ejemplo, porque se pego la linea con curl), se descargan y se continua
# desde la copia descargada.
# ---------------------------------------------------------------------------
AQUI="$(cd "$(dirname "$0")" 2>/dev/null && pwd || pwd)"
if [ ! -f "$AQUI/../comun/setup-claude.sh" ]; then
  CURSO_DESTINO="$HOME/curso-tablero-director"
  paso "Descargando los materiales del curso a $CURSO_DESTINO ..."
  TMPC="$(mktemp -d)"
  curl -fL --progress-bar -o "$TMPC/curso.zip" \
    https://github.com/dragones-tech/curso-tablero-director/archive/refs/heads/main.zip \
    || error "No se pudieron descargar los materiales del curso. Revisa tu conexion a internet y vuelve a pegar la linea."
  ditto -x -k "$TMPC/curso.zip" "$TMPC/x"
  ORIGEN_CURSO="$(find "$TMPC/x" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  [ -n "$ORIGEN_CURSO" ] || error "La descarga de los materiales del curso llego vacia. Vuelve a pegar la linea."
  mkdir -p "$CURSO_DESTINO"
  ditto "$ORIGEN_CURSO" "$CURSO_DESTINO"   # copia encima: actualiza sin borrar nada
  rm -rf "$TMPC"
  exec bash "$CURSO_DESTINO/instalacion/mac/instalar-mac.sh"
fi
INSTALACION="$(cd "$AQUI/.." && pwd)"
CURSO="$(dirname "$INSTALACION")"

# ---------------------------------------------------------------------------
# 0. Revisar la computadora
# ---------------------------------------------------------------------------

VERSION_MAC="$(sw_vers -productVersion)"
if [ "${VERSION_MAC%%.*}" -lt 13 ]; then
  error "Se necesita macOS 13 (Ventura) o mas reciente. Tienes $VERSION_MAC. Actualiza desde Configuracion del Sistema > General > Actualizacion de software."
fi

# Procesador. Si la Terminal corre con Rosetta, uname dice x86_64 aunque sea un M.
ARCH="$(uname -m)"
if [ "$ARCH" = "x86_64" ] && [ "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" = "1" ]; then
  ARCH="arm64"
fi
case "$ARCH" in
  arm64)  RD_ARCH="aarch64"; NOMBRE_CPU="Apple Silicon (M)" ;;
  x86_64) RD_ARCH="x86_64";  NOMBRE_CPU="Intel" ;;
  *) error "Procesador no reconocido: $ARCH" ;;
esac

RAM_GB=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
LIBRE_GB=$(df -g "$HOME" | awk 'NR==2 {print $4}')
paso "Mac con macOS $VERSION_MAC, procesador $NOMBRE_CPU, ${RAM_GB} GB de memoria, ${LIBRE_GB} GB libres."
[ "$RAM_GB" -ge 8 ] || aviso "Se recomiendan 8 GB de memoria; con menos puede ir lento."
[ "$LIBRE_GB" -ge 15 ] || error "Se necesitan al menos 15 GB libres en el disco. Tienes ${LIBRE_GB} GB."

# ---------------------------------------------------------------------------
# 1. Command Line Tools de Apple (Git)
# ---------------------------------------------------------------------------
if xcode-select -p >/dev/null 2>&1; then
  paso "Las herramientas de Apple ya estan instaladas."
else
  paso "Instalando las herramientas de Apple (traen Git)..."
  echo "   Va a aparecer una ventana: haz clic en 'Instalar' y luego en 'Aceptar'."
  echo "   Puede tardar de 5 a 20 minutos. Este script espera solo."
  xcode-select --install >/dev/null 2>&1 || true
  ESPERA=0
  until xcode-select -p >/dev/null 2>&1; do
    sleep 10
    ESPERA=$((ESPERA + 10))
    [ "$ESPERA" -lt 3600 ] || error "Las herramientas de Apple no terminaron de instalarse. Vuelve a ejecutar este script."
  done
fi
git --version

# ---------------------------------------------------------------------------
# 2. Rancher Desktop (Docker Engine de Linux)
# ---------------------------------------------------------------------------
APP=""
for d in "/Applications" "$HOME/Applications"; do
  [ -d "$d/Rancher Desktop.app" ] && APP="$d/Rancher Desktop.app" && break
done

if [ -n "$APP" ]; then
  paso "Rancher Desktop ya esta instalado en $APP (se actualiza solo desde la app)."
else
  paso "Descargando Rancher Desktop para $NOMBRE_CPU (unos 700 MB)..."
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  URL="$(curl -fsSL https://api.github.com/repos/rancher-sandbox/rancher-desktop/releases/latest \
        | grep -o "\"browser_download_url\": *\"[^\"]*-mac\.${RD_ARCH}\.zip\"" \
        | sed 's/.*"\(https[^"]*\)"$/\1/' | head -n 1 || true)"
  [ -n "$URL" ] || error "No se encontro la descarga de Rancher Desktop. Revisa tu conexion a internet."
  ZIP="$TMP/$(basename "$URL")"
  curl -fL --progress-bar -o "$ZIP" "$URL"

  # Verificar que la descarga llego completa
  ESPERADO="$(curl -fsSL "$URL.sha512sum" | awk '{print $1}' || true)"
  OBTENIDO="$(shasum -a 512 "$ZIP" | awk '{print $1}')"
  [ "$ESPERADO" = "$OBTENIDO" ] || error "La descarga de Rancher Desktop llego danada. Vuelve a ejecutar este script."

  ditto -x -k "$ZIP" "$TMP/app"
  ORIGEN_APP="$(find "$TMP/app" -maxdepth 2 -name 'Rancher Desktop.app' -type d | head -n 1)"
  [ -n "$ORIGEN_APP" ] || error "No se encontro Rancher Desktop.app dentro de la descarga."

  # /Applications si la cuenta puede escribir ahi; si no, la carpeta Aplicaciones del usuario
  if [ -w /Applications ]; then DESTINO_APPS="/Applications"; else DESTINO_APPS="$HOME/Applications"; mkdir -p "$DESTINO_APPS"; fi
  ditto "$ORIGEN_APP" "$DESTINO_APPS/Rancher Desktop.app"
  APP="$DESTINO_APPS/Rancher Desktop.app"
  paso "Rancher Desktop instalado en $APP"
fi

RDCTL="$(find "$APP/Contents" -name rdctl -type f -perm -u+x 2>/dev/null | head -n 1)"
[ -n "$RDCTL" ] || error "No se encontro la herramienta rdctl dentro de Rancher Desktop."

# Configuracion del curso:
# moby = Docker Engine (por defecto Rancher usa containerd, que no trae el comando docker);
# sin Kubernetes; arranca sola al iniciar sesion y sin ventana; sin acceso de
# administrador; agrega ~/.rd/bin (docker) al PATH de la terminal.
CONFIG='{"containerEngine":{"name":"moby"},"kubernetes":{"enabled":false},"application":{"adminAccess":false,"autoStart":true,"startInBackground":true,"pathManagementStrategy":"rcfiles"}}'

# Antes del primer arranque se deja como "perfil de valores por defecto"
# (solo se aplica si Rancher Desktop aun no tiene configuracion guardada).
PERFIL="$HOME/Library/Preferences/io.rancherdesktop.profile.defaults.plist"
if [ ! -f "$HOME/Library/Application Support/rancher-desktop/settings.json" ] && [ ! -f "$PERFIL" ]; then
  if ! "$RDCTL" create-profile --output plist --body "$CONFIG" > "$PERFIL" 2>/dev/null || [ ! -s "$PERFIL" ]; then
    # Respaldo: el ejemplo de la documentacion de Rancher Desktop con plutil
    plutil -create xml1 "$PERFIL"
    plutil -insert version -integer 18 "$PERFIL"
    plutil -insert containerEngine -dictionary "$PERFIL"
    plutil -insert containerEngine.name -string moby "$PERFIL"
    plutil -insert kubernetes -dictionary "$PERFIL"
    plutil -insert kubernetes.enabled -bool false "$PERFIL"
  fi
fi

paso "Arrancando Rancher Desktop (la primera vez tarda unos minutos)..."
echo "   Si aparece una ventana de bienvenida, deja las opciones como estan y haz clic en Aceptar."
echo "   Si macOS pregunta si permites que Rancher Desktop haga algo, responde que si."
# Con la app ya instalada, esto tambien corrige la configuracion si alguien la cambio.
"$RDCTL" start \
  --container-engine.name moby \
  --kubernetes.enabled=false \
  --application.admin-access=false \
  --application.auto-start=true \
  --application.start-in-background=true \
  --application.path-management-strategy rcfiles \
  --no-modal-dialogs >/dev/null 2>&1 \
  || open -a "$APP" \
  || aviso "No se pudo abrir Rancher Desktop; abrelo desde Aplicaciones."

export PATH="$HOME/.rd/bin:$PATH"
if ! grep -q '.rd/bin' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.rd/bin:$PATH"' >> "$HOME/.zshrc"
fi

ESPERA=0
until docker info >/dev/null 2>&1; do
  sleep 5
  ESPERA=$((ESPERA + 5))
  [ "$ESPERA" -lt 900 ] || error "Docker no arranco. Abre Rancher Desktop desde Aplicaciones, espera a que termine de cargar y vuelve a ejecutar este script."
done
paso "Docker listo: $(docker --version)"

# ---------------------------------------------------------------------------
# 3. Claude Code y herdr (mismo script que en Windows)
# ---------------------------------------------------------------------------
paso "Instalando / actualizando Claude Code y herdr..."
bash "$INSTALACION/comun/setup-claude.sh"
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# 4. Proyecto del curso
# ---------------------------------------------------------------------------
paso "Copiando el proyecto y los archivos de ejemplo a ~/proyecto-python y arrancando la aplicacion..."
bash "$INSTALACION/comun/build-proyecto.sh" "$INSTALACION/proyecto" "$CURSO/alumnos"

printf '\n\033[1;32m==================================================================\n'
printf ' Listo. Tu aplicacion ya se ve en el navegador:  http://localhost:8000\n'
printf ' Para trabajar abre una Terminal NUEVA y escribe:\n'
printf '   cd ~/proyecto-python\n'
printf '   claude\n'
printf ' Los archivos de ejemplo estan en ~/proyecto-python/archivos_ejemplo\n'
printf '==================================================================\033[0m\n'
