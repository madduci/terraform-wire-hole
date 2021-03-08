#!/usr/bin/env bash

docker run -it --rm \
  -v $(pwd)/config:/usr/local/etc \
  romeupalos/noip -C