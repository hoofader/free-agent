ensure_ollama

echo "Starting ${MODEL} interactive chat..."
echo "(Type /bye to exit)"
echo ""
ollama run "$MODEL"
