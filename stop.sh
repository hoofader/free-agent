#!/usr/bin/env bash
set -euo pipefail

echo "Stopping Ollama server..."
pkill ollama 2>/dev/null && echo "Stopped." || echo "Ollama was not running."
