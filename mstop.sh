#!/bin/bash
# shellcheck disable=SC2164

function stop() {
  if [ "$1" ]; then
    ps -ef | grep "python" | grep "launch.py" | grep -v "grep" | grep "$1" | awk '{print $2}' | xargs kill
    echo "stop $1"
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
    stop "$port"
  done
else
  if [ "$1" ]; then
    port=$1
  else
    port=7860
  fi
  echo "stop webui on port $port"
  stop "$port"
fi