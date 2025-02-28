# init llama-cpp first
mkdir -p /llm/llama-cpp
cd /llm/llama-cpp
init-llama-cpp

# change the model_path to run
if [[ "$DEVICE" == "Arc" || "$DEVICE" == "ARC" ]]; then
    source ipex-llm-init -g --device Arc
elif [[ "$DEVICE" == "Flex" || "$DEVICE" == "FLEX" ]]; then
    source ipex-llm-init -g --device Flex
elif [[ "$DEVICE" == "Max" || "$DEVICE" == "MAX" ]]; then
    source ipex-llm-init -g --device Max
else
    echo "Invalid DEVICE specified."
fi
model="/local_models/"$bench_model

promt_9_512="long long time ago, there is a"

# warm-up two times
./llama-cli -m $model -n 512 --prompt "${promt_9_512}"  -t 8 -e -ngl 999 --color --ctx-size 4096 --no-mmap --temp 0.7 -s 0
./llama-cli -m $model -n 512 --prompt "${promt_9_512}"  -t 8 -e -ngl 999 --color --ctx-size 4096 --no-mmap --temp 0.7 -s 0

./llama-cli -m $model -n 512 --prompt "${promt_9_512}"  -t 8 -e -ngl 999 --color --ctx-size 4096 --no-mmap --temp 0.7 -s 0
