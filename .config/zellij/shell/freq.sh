#!/bin/sh

# obtain the current frequency of the CPU
current_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | awk '{printf "%.1f", $1/1000000}')
echo "$current_freq"
