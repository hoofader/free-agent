#!/usr/bin/env bash
set -euo pipefail

MODEL="gemma3:27b"

# Ensure Ollama is running
if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo "Starting Ollama server..."
  ollama serve &
  sleep 3
fi

echo "Starting ${MODEL} interactive chat..."
echo "(Type /bye to exit)"
echo ""
ollama run "$MODEL"
