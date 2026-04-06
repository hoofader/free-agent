echo "Stopping Ollama server..."
pkill ollama 2>/dev/null && echo "Stopped." || echo "Ollama was not running."
