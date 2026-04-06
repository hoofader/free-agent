# free-agent

Run AI coding agents locally via [Ollama](https://ollama.com). No API key. No cloud. No bill.

Defaults to the best [Gemma](https://deepmind.google/models/gemma/) model for your machine, but works with any Ollama model.

## Requirements

- macOS (Apple Silicon) or Linux
- [Homebrew](https://brew.sh) (recommended on macOS)

## Quick Start

```bash
./setup.sh          # install Ollama + pull the best model for your machine
./chat.sh           # interactive chat
```

## Choosing a Model

The model is resolved in this order:

1. **`FREE_AGENT_MODEL` env var** — `FREE_AGENT_MODEL=llama3.3 ./chat.sh`
2. **`.model` file** — create a `.model` file with the model name (e.g. `qwen2.5-coder:32b`)
3. **Auto-detect** — picks the best Gemma 3 model based on system RAM:

| RAM | Model |
|--------|--------------|
| 32 GB+ | `gemma3:27b` |
| 16 GB+ | `gemma3:12b` |
| 10 GB+ | `gemma3:4b` |
| < 10 GB | `gemma3:1b` |

## Aider (code editing agent)

[Aider](https://github.com/Aider-AI/aider) uses its own edit-format protocol — no LLM tool-calling needed, so it works reliably with any local model.

```bash
./aider-setup.sh    # create venv + install aider-chat
./aider-run.sh      # launch aider
```

## nano-claude-code (full Claude Code experience)

[nano-claude-code](https://github.com/SafeRL-Lab/nano-claude-code) is a model-agnostic reimplementation of Claude Code with native Ollama support. Gives your model autonomous tool access: file read/write/edit, bash, web fetch/search, sub-agents, MCP, and more.

```bash
./ncc-setup.sh      # clone repo + install deps + configure
./ncc-run.sh        # launch nano-claude-code
```

### Which to use?

| | Aider | nano-claude-code |
|---|---|---|
| **Best for** | Code editing, refactoring | General-purpose agentic tasks |
| **Tool calling** | Not needed (own protocol) | Uses Ollama tool-calling API |
| **Web access** | No | Yes (fetch, search) |
| **Bash execution** | User-initiated (`/run`) | Autonomous (with permission gate) |
| **Model flexibility** | High (any model works) | Depends on model's tool-calling quality |

## Scripts

| Script | Purpose |
|-----------------|------------------------------------------------|
| `setup.sh` | Install Ollama and pull the selected model |
| `chat.sh` | Interactive chat |
| `api.sh` | Single-prompt API call: `./api.sh "prompt"` |
| `stop.sh` | Stop the Ollama server |
| `aider-setup.sh` | Install Aider in a venv |
| `aider-run.sh` | Launch Aider |
| `ncc-setup.sh` | Clone + install nano-claude-code |
| `ncc-run.sh` | Launch nano-claude-code |

## API Usage

Ollama exposes an OpenAI-compatible API at `http://localhost:11434`:

```bash
./api.sh "Explain quantum computing in one paragraph"

# Or with a specific model:
FREE_AGENT_MODEL=mistral ./api.sh "Hello!"
```
