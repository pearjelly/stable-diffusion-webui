#!/bin/bash
seed=$1
work_dir=$2
vsize=$3
cd "${work_dir}" || exit
mmv "*-${seed}.png" "${seed}-#1.png"
ffmpeg -r 25 -f image2 -i "${seed}"-%5d.png -vcodec libx264 -pix_fmt yuv420p -s "${vsize}" -crf 1 -y "${seed}".mp4