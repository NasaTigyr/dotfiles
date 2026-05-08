#!/bin/bash

source ~/esp/esp-idf/export.sh
idf.py build
idf.py -p /dev/ttyACM0 flash
if [ "$1" = "m" ]; then
  idf.py -p /dev/ttyACM0 monitor
fi
