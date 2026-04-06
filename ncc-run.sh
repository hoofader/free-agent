#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NCC_DIR="$SCRIPT_DIR/nano-claude-code"
VENV_DIR="$SCRIPT_DIR/.venv-ncc"

if [ ! -d "$VENV_DIR" ] || [ ! -d "$NCC_DIR" ]; then
  echo "Run ./ncc-setup.sh first."
  exit 1
fi

# Ensure Ollama is running
if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo "Starting Ollama server..."
  ollama serve &
  sleep 3
fi

exec "$VENV_DIR/bin/python3" "$NCC_DIR/nano_claude.py" "$@"
