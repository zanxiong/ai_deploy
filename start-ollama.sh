# init ollama first
mkdir -p /llm/ollama
cd /llm/ollama
init-ollama
export OLLAMA_NUM_GPU=999
export ZES_ENABLE_SYSMAN=1

export OLLAMA_KEEP_ALIVE=-1
./ollama serve > ollama.log 2>&1 &
