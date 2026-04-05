#!/usr/bin/env bash
set -euo pipefail

echo "=== Gemma Local Setup ==="

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

# Start Ollama server if not running
if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo "Starting Ollama server..."
  ollama serve &
  sleep 3
fi

# Pull the model
MODEL="gemma3:27b"
echo "Pulling ${MODEL} (this may take a while on first run)..."
ollama pull "$MODEL"

echo ""
echo "Setup complete! Run ./chat.sh to start chatting."
