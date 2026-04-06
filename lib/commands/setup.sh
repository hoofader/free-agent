echo "=== free-agent setup ==="

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

if [[ "$TOOLS_MODEL" != "$MODEL" ]]; then
  echo "Pulling ${TOOLS_MODEL} (tool-calling model for ncc)..."
  ollama pull "$TOOLS_MODEL"
fi

echo ""
echo "Setup complete! Run './free-agent chat' to start chatting."
echo "Model: $MODEL"
echo "Tools model: $TOOLS_MODEL"
