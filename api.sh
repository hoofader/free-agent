#!/usr/bin/env bash
set -euo pipefail

MODEL="gemma3:27b"
PROMPT="${1:?Usage: ./api.sh \"your prompt here\"}"

# Ensure Ollama is running
if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo "Starting Ollama server..." >&2
  ollama serve &
  sleep 3
fi

curl -s http://localhost:11434/api/generate \
  -d "$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" \
    '{model: $model, prompt: $prompt, stream: false}')" \
  | jq -r '.response'
