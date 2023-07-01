#!/bin/bash
# shellcheck disable=SC2164
cd /home/ubuntu/stable-diffusion-webui

function stop() {
  if [ -f "$1" ]; then
    pid=$(cat "$1")
    echo "stop $pid"
    kill "$pid"
    rm -f "$1"
  else
    echo "$1 not exist"
  fi
}

#如果 $1 是 'all'，则查询gpu数量设置为gpu_num，从0开始依次停止gpu_num个webui，端口号从7860开始
if [ "$1" = "all" ]; then
  gpu_num=$(nvidia-smi -L | wc -l)
  echo "stop webui on $gpu_num gpus"
  # shellcheck disable=SC2039
  for ((i = 0; i < gpu_num; i++)); do
    port=$((7860 + i))
    echo "stop webui on port $port with device id $i"
    stop run/stable-diffusion-"$port".pid
  done
else
  if [ "$1" ]; then
    port=$1
  else
    port=7860
  fi
  echo "stop webui on port $port"
  stop run/stable-diffusion-"$port".pid
fi