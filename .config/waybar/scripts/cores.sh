#!/usr/bin/env bash

# obtiene numero de cores
cores=$(nproc)

# obtiene frecuencia actual
freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{printf "%.1f", $1/1000000}' || echo 'N/A')

# formatea con bold solo en el valor de frecuencia
echo "{\"text\": \"${cores}x<b>${freq}</b>GHz\", \"class\": \"cores\"}"