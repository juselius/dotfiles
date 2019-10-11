#!/usr/bin/env fish
docker run -d \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v (pwd):(pwd) \
    -e DISPLAY=$DISPLAY \
    hackenfreude/tlatoolbox-1.5.2
