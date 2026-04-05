# Gemma 3 27B Local Setup

Run Google's Gemma 3 27B model locally via [Ollama](https://ollama.com) on Apple Silicon.

## Requirements

- macOS with Apple Silicon (M1/M2/M3/M4)
- 36 GB+ unified memory
- [Homebrew](https://brew.sh) (recommended)

## Quick Start

```bash
./setup.sh    # install Ollama + pull the model
./chat.sh     # interactive chat
```

## Scripts

| Script | Purpose |
|-----------|----------------------------------------------|
| `setup.sh` | Install Ollama and download Gemma 3 27B |
| `chat.sh` | Start an interactive chat session |
| `api.sh` | Single-prompt API call: `./api.sh "prompt"` |
| `stop.sh` | Stop the Ollama server |

## Model Details

- **Model:** `gemma3:27b` (Q4_K_M quantized, ~17 GB)
- **Context window:** 128K tokens
- **Capabilities:** Text generation, reasoning, instruction following
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
