#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib/config.sh"
ensure_ollama

echo "Starting ${MODEL} interactive chat..."
echo "(Type /bye to exit)"
echo ""
ollama run "$MODEL"
