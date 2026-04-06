NCC_DIR="$SCRIPT_DIR/nano-claude-code"
VENV_DIR="$SCRIPT_DIR/.venv-ncc"
SUBCMD="${1:-run}"

case "$SUBCMD" in
  setup)
    if ! command -v python3 &>/dev/null; then
      echo "Error: python3 is required. Install it with: brew install python3"
      exit 1
    fi

    if [ -d "$NCC_DIR" ]; then
      echo "Updating nano-claude-code..."
      git -C "$NCC_DIR" pull --ff-only
    else
      echo "Cloning nano-claude-code..."
      git clone https://github.com/SafeRL-Lab/nano-claude-code.git "$NCC_DIR"
    fi

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

    CONFIG_DIR="$HOME/.nano_claude"
    CONFIG_FILE="$CONFIG_DIR/config.json"
    mkdir -p "$CONFIG_DIR"

    if [ ! -f "$CONFIG_FILE" ]; then
      echo "Writing default config for Ollama + ${MODEL}..."
      cat > "$CONFIG_FILE" << CONF
{
  "model": "ollama/${MODEL}",
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
      echo "To use ${MODEL}, set model to: ollama/${MODEL}"
    fi

    echo ""
    echo "Setup complete! Run './free-agent ncc' to start."
    echo "Model: $MODEL"
    ;;
  run)
    if [ ! -d "$VENV_DIR" ] || [ ! -d "$NCC_DIR" ]; then
      echo "Run './free-agent ncc setup' first."
      exit 1
    fi

    ensure_ollama

    exec "$VENV_DIR/bin/python3" "$NCC_DIR/nano_claude.py" "${@:2}"
    ;;
  *)
    echo "Usage: ./free-agent ncc [setup|run]" >&2
    exit 1
    ;;
esac
