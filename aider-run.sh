#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib/config.sh"

VENV_DIR="$SCRIPT_DIR/.venv-aider"

if [ ! -d "$VENV_DIR" ]; then
  echo "Run ./aider-setup.sh first."
  exit 1
fi

ensure_ollama
export OLLAMA_API_BASE=http://127.0.0.1:11434

exec "$VENV_DIR/bin/aider" \
  --model "ollama_chat/$MODEL" \
  "$@"
