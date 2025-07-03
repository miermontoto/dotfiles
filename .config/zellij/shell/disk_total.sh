#!/bin/bash

echo "$(df -BG / | grep '/' | awk '{print $2}' | sed 's/G//')"
