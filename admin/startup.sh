#!/bin/bash
cmd=$1
cnt=$2
# shellcheck disable=SC2164
sudo mount /dev/vdb1 /home/ubuntu/ext_models
cd /home/ubuntu/stable-diffusion-webui
gpu_num=$(nvidia-smi -L | wc -l)
for ((i = 0; i < cnt; i++)); do
  port=$((7860 + i))
  if [ "$cmd" = "start" ]; then
    ./mstart.sh "$port" "$((i % gpu_num))"
  elif [ "$cmd" = "stop" ]; then
    ./mstop.sh "$port" "$((i % gpu_num))"
  elif [ "$cmd" = "restart" ]; then
    ./mstop.sh "$port" "$((i % gpu_num))"
    ./mstart.sh "$port" "$((i % gpu_num))"
  else
    echo "unknown command $cmd"
    exit 1
  fi
done
