#!/usr/bin/env bash

docker run -it --rm \
  -v $(pwd):/usr/local/etc \
  romeupalos/noip -C