#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib/config.sh"

NCC_DIR="$SCRIPT_DIR/nano-claude-code"
VENV_DIR="$SCRIPT_DIR/.venv-ncc"

if [ ! -d "$VENV_DIR" ] || [ ! -d "$NCC_DIR" ]; then
  echo "Run ./ncc-setup.sh first."
  exit 1
fi

ensure_ollama

exec "$VENV_DIR/bin/python3" "$NCC_DIR/nano_claude.py" "$@"
