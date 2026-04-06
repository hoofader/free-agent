#!/usr/bin/env bash
set -euo pipefail

echo "=== Aider Setup ==="

# Check Python 3
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required. Install it with: brew install python3"
  exit 1
fi

# Create venv if needed
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv-aider"

if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

echo "Installing aider-chat..."
"$VENV_DIR/bin/pip" install -q aider-chat

echo ""
echo "Setup complete! Run ./aider-run.sh to start."
