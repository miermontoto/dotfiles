#!/bin/bash

echo "$(free -m | awk 'NR==2{printf "%.1f\n", $2/1024}')"
