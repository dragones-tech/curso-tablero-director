#!/usr/bin/env bash
# Se ejecuta como el usuario normal dentro de Ubuntu (WSL).
# Instala Claude Code y herdr (multiplexor de terminal para agentes) y los
# actualiza a la ultima version.
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
export PATH="$BIN_DIR:$PATH"

# Asegurar ~/.local/bin en el PATH de las terminales nuevas
if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

if command -v claude >/dev/null 2>&1; then
  echo ">> Claude Code ya esta instalado: $(claude --version)"
else
  echo ">> Instalando Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

echo ">> Buscando actualizaciones de Claude Code..."
claude update || echo ">> AVISO: no se pudo actualizar (se reintentara automaticamente al usarlo)."

echo ">> Claude Code listo: $(claude --version)"

# --- herdr (https://herdr.dev/tui/) ---
if command -v herdr >/dev/null 2>&1; then
  echo ">> herdr ya esta instalado."
else
  echo ">> Instalando herdr..."
  curl -fsSL https://herdr.dev/install.sh | sh
  hash -r
fi

if command -v herdr >/dev/null 2>&1; then
  echo ">> Buscando actualizaciones de herdr..."
  herdr update || echo ">> AVISO: no se pudo actualizar herdr."
  # La integracion necesita que exista ~/.claude; se reinstala tras cada
  # actualizacion, como recomienda la documentacion de herdr.
  mkdir -p "$HOME/.claude"
  herdr integration install claude || echo ">> AVISO: no se pudo instalar la integracion herdr-Claude."
  echo ">> herdr listo."
else
  echo ">> AVISO: herdr no quedo en el PATH; abre una terminal nueva y ejecuta 'herdr'."
fi

echo ">> Para iniciar sesion abre Ubuntu y ejecuta: claude"
