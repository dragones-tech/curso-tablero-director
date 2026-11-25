#!/usr/bin/env bash
# Se ejecuta como root dentro de Ubuntu (WSL). Uso: setup-docker.sh <usuario_linux>
set -euo pipefail

LINUX_USER="${1:?Falta el usuario de Linux}"

export DEBIAN_FRONTEND=noninteractive

echo ">> Instalando / actualizando git y curl..."
apt-get update -y
apt-get install -y git curl ca-certificates
echo ">> $(git --version)"

echo ">> Activando systemd en WSL..."
if ! grep -q "^systemd=true" /etc/wsl.conf 2>/dev/null; then
  printf "[boot]\nsystemd=true\n" >> /etc/wsl.conf
fi

if command -v docker >/dev/null 2>&1; then
  echo ">> Docker ya esta instalado: $(docker --version)"
else
  echo ">> Instalando Docker Engine (repositorio oficial)..."
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo ">> Agregando '$LINUX_USER' al grupo docker..."
usermod -aG docker "$LINUX_USER"
systemctl enable docker >/dev/null 2>&1 || true

echo ">> Docker instalado."
