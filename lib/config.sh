#!/usr/bin/env bash
# Shared configuration for free-agent scripts.
# Source this file — do not execute directly.
#
# Model resolution order (FREE_AGENT_MODEL / FREE_AGENT_TOOLS_MODEL):
#   1. Environment variable
#   2. .model / .tools-model file in project root (single line: model name)
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

# Gemma 4 has native tool calling, so we use the same model for both.
# Fall back to Gemma 3 + gemma3-tools for machines that can't run any Gemma 4.

_auto_select_model() {
  local ram_gb
  ram_gb=$(_detect_ram_gb)

  if (( ram_gb >= 48 )); then
    echo "gemma4:31b"
  elif (( ram_gb >= 22 )); then
    echo "gemma4:26b"
  elif (( ram_gb >= 12 )); then
    echo "gemma4:e4b"
  elif (( ram_gb >= 9 )); then
    echo "gemma4:e2b"
  elif (( ram_gb >= 4 )); then
    echo "gemma3:4b"
  else
    echo "gemma3:1b"
  fi
}

_auto_select_tools_model() {
  local ram_gb
  ram_gb=$(_detect_ram_gb)

  # Gemma 4 supports tool calling natively
  if (( ram_gb >= 48 )); then
    echo "gemma4:31b"
  elif (( ram_gb >= 22 )); then
    echo "gemma4:26b"
  elif (( ram_gb >= 12 )); then
    echo "gemma4:e4b"
  elif (( ram_gb >= 9 )); then
    echo "gemma4:e2b"
  # Fall back to gemma3-tools fine-tune
  elif (( ram_gb >= 4 )); then
    echo "orieg/gemma3-tools:12b-ft"
  else
    echo "orieg/gemma3-tools:4b-ft"
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

_resolve_tools_model() {
  if [[ -n "${FREE_AGENT_TOOLS_MODEL:-}" ]]; then
    echo "$FREE_AGENT_TOOLS_MODEL"
    return
  fi

  if [[ -f "$SCRIPT_DIR/.tools-model" ]]; then
    head -1 "$SCRIPT_DIR/.tools-model" | tr -d '[:space:]'
    return
  fi

  _auto_select_tools_model
}

MODEL="$(_resolve_model)"
TOOLS_MODEL="$(_resolve_tools_model)"

# ── Python detection ─────────────────────────────────────────────────────────

_find_python() {
  # Prefer Python 3.11-3.13 (3.14+ has compatibility issues with many packages)
  for v in python3.13 python3.12 python3.11; do
    if command -v "$v" &>/dev/null; then
      echo "$v"
      return
    fi
  done
  # Fall back to default python3
  if command -v python3 &>/dev/null; then
    echo "python3"
    return
  fi
  echo "Error: python3 is required. Install it with: brew install python@3.12" >&2
  exit 1
}

PYTHON="$(_find_python)"

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
