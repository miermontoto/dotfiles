#!/bin/sh

# Get the 1-minute load average
load=$(cat /proc/loadavg | awk '{printf "%.2f", $1}')
echo "$load"
