#!/bin/bash
v_name=$1
mkdir "${v_name}"
ffmpeg -i "${v_name}".mp4 -r 25 -f image2  "${v_name}"/"${v_name}"-%05d.png