#!/bin/bash
v_name=$1
ffmpeg -i "${v_name}".mp4 -r 30 -f image2  "${v_name}"/"${v_name}"-%05d.png