#!/bin/bash
#如果 $1 是 'all'，则查询gpu数量设置为gpu_num，从0开始依次启动gpu_num个webui，端口号从7860开始
# shellcheck disable=SC2164
cd /home/ubuntu/stable-diffusion-webui
source venv/bin/activate

if [ "$1" = "all" ]; then
  gpu_num=$(nvidia-smi -L | wc -l)
  echo "start webui on $gpu_num gpus"
  # shellcheck disable=SC2039
  for ((i = 0; i < gpu_num; i++)); do
    port=$((7860 + i))
    echo "start webui on port $port with device id $i"
    export CUDA_VISIBLE_DEVICES="$i"
    nohup ./webui.sh --port "$port" >>log/stable-diffusion-"$port".log 2>&1 &
    echo $! >./run/stable-diffusion-"$port".pid
  done
else
  if [ "$1" ]; then
    port=$1
  else
    port=7860
  fi

  if [ "$2" ]; then
    # $2 is number >= 0 and <= 3, explict gpu use --device-id $2
    if [ "$2" -ge 0 ] && [ "$2" -le 3 ]; then
      echo "start webui on port $port with device id $2"
      export CUDA_VISIBLE_DEVICES="$2"
      nohup ./webui.sh --port "$port" >>log/stable-diffusion-"$port".log 2>&1 &
      echo $! >./run/stable-diffusion-"$port".pid
    # $2 is checkpoint path, use --ckpt $2
    else
      echo "start webui on port $port with checkpoint $2"
      nohup ./webui.sh --port "$port" --ckpt "$2" >>log/stable-diffusion-"$port".log 2>&1 &
      echo $! >./run/stable-diffusion-"$port".pid
    fi
  else
    echo "start webui on port $port"
    nohup ./webui.sh --port "$port" >>log/stable-diffusion-"$port".log 2>&1 &
    echo $! >./run/stable-diffusion-"$port".pid
  fi

fi
