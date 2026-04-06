#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib/config.sh"

PROMPT="${1:?Usage: ./api.sh \"your prompt here\"}"

ensure_ollama

curl -s http://localhost:11434/api/generate \
  -d "$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" \
    '{model: $model, prompt: $prompt, stream: false}')" \
  | jq -r '.response'
