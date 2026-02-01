#!/bin/bash

# script para cambiar el perfil de energía
# uso: ./set-power-profile.sh [performance|balanced|power-saver]

profile=$1

if command -v tuned-adm &> /dev/null; then
    # usar tuned si está disponible (no requiere sudo)
    case "$profile" in
        "performance")
            # intentar diferentes perfiles de performance
            tuned-adm profile latency-performance 2>/dev/null || \
            tuned-adm profile throughput-performance 2>/dev/null || \
            tuned-adm profile desktop
            ;;
        "power-saver")
            # intentar perfiles de ahorro de energía
            tuned-adm profile powersave 2>/dev/null || \
            tuned-adm profile balanced-battery 2>/dev/null || \
            tuned-adm profile laptop-battery-powersave 2>/dev/null || \
            tuned-adm profile laptop
            ;;
        "balanced")
            tuned-adm profile balanced 2>/dev/null || \
            tuned-adm profile desktop
            ;;
    esac
elif command -v powerprofilesctl &> /dev/null; then
    # usar powerprofilesctl si está disponible
    powerprofilesctl set "$profile"
elif command -v cpupower &> /dev/null; then
    # usar cpupower si está disponible (requiere sudo)
    case "$profile" in
        "performance")
            sudo cpupower frequency-set -g performance
            ;;
        "power-saver")
            sudo cpupower frequency-set -g powersave
            ;;
        "balanced")
            sudo cpupower frequency-set -g schedutil 2>/dev/null || \
            sudo cpupower frequency-set -g ondemand 2>/dev/null || \
            sudo cpupower frequency-set -g conservative
            ;;
    esac
else
    # fallback directo a sysfs (requiere permisos)
    case "$profile" in
        "performance")
            echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            ;;
        "power-saver")
            echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            ;;
        "balanced")
            # intentar schedutil primero, luego ondemand
            if grep -q schedutil /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
                echo "schedutil" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            elif grep -q ondemand /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
                echo "ondemand" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            else
                echo "conservative" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            fi
            ;;
    esac
fi