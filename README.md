# Gemma 3 27B Local Setup

Run Google's Gemma 3 27B model locally via [Ollama](https://ollama.com) on Apple Silicon.

## Requirements

- macOS with Apple Silicon (M1/M2/M3/M4)
- 36 GB+ unified memory
- [Homebrew](https://brew.sh) (recommended)

## Quick Start

```bash
./setup.sh          # install Ollama + pull the model
./chat.sh           # interactive chat (vanilla)
```

## Aider (code editing agent)

[Aider](https://github.com/Aider-AI/aider) uses its own edit-format protocol — no LLM tool-calling needed, so it works reliably with Gemma 3 27B.

```bash
./aider-setup.sh    # create venv + install aider-chat
./aider-run.sh      # launch aider with Gemma 3 27B
```

Use it inside any git repo to edit code conversationally. Aider reads/writes files directly, runs tests via `/run` and `/test`, and auto-commits changes.

## nano-claude-code (full Claude Code experience)

[nano-claude-code](https://github.com/SafeRL-Lab/nano-claude-code) is a model-agnostic reimplementation of Claude Code with native Ollama support. Gives Gemma autonomous tool access: file read/write/edit, bash, web fetch/search, sub-agents, MCP, and more.

```bash
./ncc-setup.sh      # clone repo + install deps + configure for Gemma
./ncc-run.sh        # launch nano-claude-code with Gemma 3 27B
```

### Which to use?

| | Aider | nano-claude-code |
|---|---|---|
| **Best for** | Code editing, refactoring | General-purpose agentic tasks |
| **Tool calling** | Not needed (own protocol) | Uses Ollama tool-calling API |
| **Web access** | No | Yes (fetch, search) |
| **Bash execution** | User-initiated (`/run`) | Autonomous (with permission gate) |
| **Reliability** | High (no tool-call dependency) | Depends on Gemma's tool-calling |

## Scripts

| Script | Purpose |
|-----------------|------------------------------------------------|
| `setup.sh` | Install Ollama and download Gemma 3 27B |
| `chat.sh` | Interactive chat (vanilla, no tools) |
| `api.sh` | Single-prompt API call: `./api.sh "prompt"` |
| `stop.sh` | Stop the Ollama server |
| `aider-setup.sh` | Install Aider in a venv |
| `aider-run.sh` | Launch Aider with Gemma 3 27B |
| `ncc-setup.sh` | Clone + install nano-claude-code |
| `ncc-run.sh` | Launch nano-claude-code with Gemma 3 27B |

## Model Details

- **Model:** `gemma3:27b` (Q4_K_M quantized, ~17 GB)
- **Context window:** 128K tokens
- **RAM usage:** ~20-24 GB during inference

## API Usage

Ollama exposes an OpenAI-compatible API at `http://localhost:11434`:

```bash
# Single prompt
./api.sh "Explain quantum computing in one paragraph"

# Direct curl
curl http://localhost:11434/api/generate -d '{
  "model": "gemma3:27b",
  "prompt": "Hello!",
  "stream": false
}'
```
