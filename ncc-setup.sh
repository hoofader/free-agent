#!/usr/bin/env bash
set -euo pipefail

echo "=== nano-claude-code Setup ==="

# Check Python 3
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required. Install it with: brew install python3"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NCC_DIR="$SCRIPT_DIR/nano-claude-code"
VENV_DIR="$SCRIPT_DIR/.venv-ncc"

# Clone or update
if [ -d "$NCC_DIR" ]; then
  echo "Updating nano-claude-code..."
  git -C "$NCC_DIR" pull --ff-only
else
  echo "Cloning nano-claude-code..."
  git clone https://github.com/SafeRL-Lab/nano-claude-code.git "$NCC_DIR"
fi

# Create venv if needed
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

echo "Installing dependencies..."
if [ -f "$NCC_DIR/requirements.txt" ]; then
  "$VENV_DIR/bin/pip" install -q -r "$NCC_DIR/requirements.txt"
else
  "$VENV_DIR/bin/pip" install -q anthropic openai rich httpx
fi

# Write config for Ollama + Gemma 3 27B
CONFIG_DIR="$HOME/.nano_claude"
CONFIG_FILE="$CONFIG_DIR/config.json"
mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Writing default config for Ollama + Gemma 3 27B..."
  cat > "$CONFIG_FILE" << 'CONF'
{
  "model": "ollama/gemma3:27b",
  "max_tokens": 40000,
  "permission_mode": "auto",
  "thinking": false,
  "thinking_budget": 10000,
  "max_tool_output": 32000,
  "max_agent_depth": 3
}
CONF
else
  echo "Config already exists at $CONFIG_FILE"
  echo "To use Gemma 3 27B, set model to: ollama/gemma3:27b"
fi

echo ""
echo "Setup complete! Run ./ncc-run.sh to start."
