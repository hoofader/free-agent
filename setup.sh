#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib/config.sh"

echo "=== free-agent setup ==="

# Install Ollama if not present
if ! command -v ollama &>/dev/null; then
  echo "Installing Ollama..."
  if command -v brew &>/dev/null; then
    brew install ollama
  else
    curl -fsSL https://ollama.com/install.sh | sh
  fi
else
  echo "Ollama already installed: $(ollama --version)"
fi

ensure_ollama

echo "Pulling ${MODEL} (this may take a while on first run)..."
ollama pull "$MODEL"

echo ""
echo "Setup complete! Run ./chat.sh to start chatting."
echo "Model: $MODEL"
