#!/usr/bin/env bash
# Shared configuration for free-agent scripts.
# Source this file — do not execute directly.
#
# Model resolution order:
#   1. FREE_AGENT_MODEL environment variable
#   2. .model file in project root (single line: model name)
#   3. Auto-detect best Gemma model based on system RAM

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ── RAM detection ────────────────────────────────────────────────────────────

_detect_ram_gb() {
  local ram_bytes
  case "$(uname -s)" in
    Darwin) ram_bytes=$(sysctl -n hw.memsize) ;;
    Linux)  ram_bytes=$(awk '/MemTotal/ {print $2 * 1024}' /proc/meminfo) ;;
    *)      ram_bytes=0 ;;
  esac
  echo $(( ram_bytes / 1073741824 ))
}

# ── Model auto-selection ─────────────────────────────────────────────────────

_auto_select_model() {
  local ram_gb
  ram_gb=$(_detect_ram_gb)

  if (( ram_gb >= 32 )); then
    echo "gemma3:27b"
  elif (( ram_gb >= 16 )); then
    echo "gemma3:12b"
  elif (( ram_gb >= 10 )); then
    echo "gemma3:4b"
  else
    echo "gemma3:1b"
  fi
}

# ── Resolve model ────────────────────────────────────────────────────────────

_resolve_model() {
  # 1. Environment variable
  if [[ -n "${FREE_AGENT_MODEL:-}" ]]; then
    echo "$FREE_AGENT_MODEL"
    return
  fi

  # 2. .model file
  if [[ -f "$SCRIPT_DIR/.model" ]]; then
    head -1 "$SCRIPT_DIR/.model" | tr -d '[:space:]'
    return
  fi

  # 3. Auto-detect
  _auto_select_model
}

MODEL="$(_resolve_model)"

# ── Ollama helpers ───────────────────────────────────────────────────────────

ensure_ollama() {
  if ! command -v ollama &>/dev/null; then
    echo "Error: ollama is not installed. Run ./setup.sh first."
    exit 1
  fi
  if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
    echo "Starting Ollama server..."
    ollama serve &
    sleep 3
  fi
}
