# init llama-cpp first
mkdir -p /llm/llama-cpp
cd /llm/llama-cpp
init-llama-cpp

# change the model_path to run
model="/models/DeepSeek-R1-Distill-Llama-8B-Q4_K_M.gguf"
./llama-cli -m $model -n 128 --prompt "long long time ago, there is a" -t 8 -e -ngl 999 --color -s 0
