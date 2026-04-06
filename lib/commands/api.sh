PROMPT="${1:?Usage: ./free-agent api \"your prompt here\"}"

ensure_ollama

curl -s http://localhost:11434/api/generate \
  -d "$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" \
    '{model: $model, prompt: $prompt, stream: false}')" \
  | jq -r '.response'
