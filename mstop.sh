#!/bin/bash
if [ "$1" ];
then
    port=$1
else
    port=7860
fi
cat run/stable-diffusion-"$port".pid | xargs kill
rm -f run/stable-diffusion-"$port".pid
