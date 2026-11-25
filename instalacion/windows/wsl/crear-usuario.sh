#!/usr/bin/env bash
# Se ejecuta como root dentro de Ubuntu (WSL), justo despues de instalarlo.
# Crea el usuario generico del curso para que nadie tenga que inventar uno.
# Uso: crear-usuario.sh <usuario> <contrasena>
#
# La contrasena solo sirve para "sudo" dentro de Ubuntu. No agrega riesgo aunque
# sea publica: Ubuntu en WSL no se expone a la red y quien entra a la cuenta de
# Windows ya puede entrar como root con "wsl -u root".
set -euo pipefail

USUARIO="${1:?Falta el usuario}"
CLAVE="${2:?Falta la contrasena}"

if id "$USUARIO" >/dev/null 2>&1; then
  echo ">> El usuario '$USUARIO' ya existe."
else
  # UID 1000: el primer usuario normal. Ubuntu revisa si existe para no volver a
  # pedir que se cree uno al abrirlo por primera vez.
  if getent passwd 1000 >/dev/null; then
    useradd -m -s /bin/bash "$USUARIO"
  else
    useradd -m -u 1000 -s /bin/bash "$USUARIO"
  fi
  echo ">> Usuario '$USUARIO' creado."
fi
usermod -aG sudo "$USUARIO"
echo "$USUARIO:$CLAVE" | chpasswd

# Usuario por defecto al abrir Ubuntu
touch /etc/wsl.conf
if grep -q '^default=' /etc/wsl.conf; then
  sed -i "s/^default=.*/default=$USUARIO/" /etc/wsl.conf
else
  printf '\n[user]\ndefault=%s\n' "$USUARIO" >> /etc/wsl.conf
fi
echo ">> '$USUARIO' es el usuario por defecto de Ubuntu."
