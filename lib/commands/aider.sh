VENV_DIR="$SCRIPT_DIR/.venv-aider"
SUBCMD="${1:-run}"

case "$SUBCMD" in
  setup)
    if [ ! -d "$VENV_DIR" ]; then
      echo "Creating virtual environment ($PYTHON)..."
      "$PYTHON" -m venv "$VENV_DIR"
    fi

    echo "Installing aider-chat..."
    "$VENV_DIR/bin/pip" install -q aider-chat

    echo ""
    echo "Setup complete! Run './free-agent aider' to start."
    ;;
  run)
    if [ ! -d "$VENV_DIR" ]; then
      echo "Run './free-agent aider setup' first."
      exit 1
    fi

    ensure_ollama
    export OLLAMA_API_BASE=http://127.0.0.1:11434

    exec "$VENV_DIR/bin/aider" \
      --model "ollama_chat/$MODEL" \
      "${@:2}"
    ;;
  *)
    echo "Usage: ./free-agent aider [setup|run]" >&2
    exit 1
    ;;
esac
