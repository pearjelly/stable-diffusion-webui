#!/bin/sh
if [ "$1" ];
then
    port=$1
else
    port=7860
fi

if [ "$2" ];
then
    nohup ./webui.sh --port "$port" --ckpt "$2" >> log/stable-diffusion-"$port".log 2>&1 &
else
    nohup ./webui.sh --port "$port" >> log/stable-diffusion-"$port".log 2>&1 &
fi

echo $! >./run/stable-diffusion-"$port".pid
