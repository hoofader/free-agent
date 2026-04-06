#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv-aider"

if [ ! -d "$VENV_DIR" ]; then
  echo "Run ./aider-setup.sh first."
  exit 1
fi

# Ensure Ollama is running
if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo "Starting Ollama server..."
  ollama serve &
  sleep 3
fi

export OLLAMA_API_BASE=http://127.0.0.1:11434

exec "$VENV_DIR/bin/aider" \
  --model "ollama_chat/gemma3:27b" \
  "$@"
