#!/usr/bin/env bash

# obtener el perfil de energía actual
if command -v tuned-adm &> /dev/null; then
    # usar tuned si está disponible
    profile=$(tuned-adm active 2>/dev/null | grep "Current active profile:" | cut -d: -f2 | xargs)
    case "$profile" in
        *performance*|*throughput*)
            profile="performance"
            ;;
        *balanced*)
            profile="balanced"
            ;;
        *powersave*|*battery*|*laptop*)
            profile="power-saver"
            ;;
        *)
            profile="balanced"
            ;;
    esac
elif command -v powerprofilesctl &> /dev/null; then
    profile=$(powerprofilesctl get 2>/dev/null)
else
    # fallback to checking cpufreq governor
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
        case "$governor" in
            "performance")
                profile="performance"
                ;;
            "powersave")
                profile="power-saver"
                ;;
            *)
                profile="balanced"
                ;;
        esac
    else
        profile="unknown"
    fi
fi

case "$profile" in
    "performance")
        profile_icon=""
        profile_name="Performance"
        ;;
    "balanced")
        profile_icon=""
        profile_name="Balanced"
        ;;
    "power-saver")
        profile_icon=""
        profile_name="Power Saver"
        ;;
    *)
        profile_icon=""
        profile_name="$profile"
        ;;
esac

# obtener información de la batería
if [ -d /sys/class/power_supply/BAT0 ] || [ -d /sys/class/power_supply/BAT1 ]; then
    # usar BAT0 o BAT1 dependiendo de cuál existe
    if [ -d /sys/class/power_supply/BAT0 ]; then
        BAT="BAT0"
    else
        BAT="BAT1"
    fi

    capacity=$(cat /sys/class/power_supply/$BAT/capacity 2>/dev/null || echo "0")
    status=$(cat /sys/class/power_supply/$BAT/status 2>/dev/null || echo "Unknown")

    # determinar el icono de batería basado en el estado y nivel
    if [ "$status" = "Charging" ]; then
        # si está cargando, usar el icono de carga
        battery_icon=""
    elif [ "$status" = "Full" ]; then
        # si está llena, usar el icono de batería llena
        battery_icon=""
    else
        # si no está cargando, usar el icono basado en el nivel
        if [ "$capacity" -ge 90 ]; then
            battery_icon=""
        elif [ "$capacity" -ge 70 ]; then
            battery_icon=""
        elif [ "$capacity" -ge 50 ]; then
            battery_icon=""
        elif [ "$capacity" -ge 30 ]; then
            battery_icon=""
        else
            battery_icon=""
        fi
    fi

    # construir el texto del módulo
    text="$profile_icon <b>$capacity</b>% $battery_icon"

    # construir el tooltip con información detallada
    tooltip="Power Profile: $profile_name\nBattery: $capacity%\nStatus: $status\n\nLeft-click: Set Power Saver\nMiddle-click: Set Balanced\nRight-click: Set Performance"

    # determinar la clase CSS basada en el estado y perfil
    css_class=""
    
    # agregar clase basada en el perfil de energía
    if [ "$profile" = "performance" ]; then
        css_class="performance"
    elif [ "$profile" = "power-saver" ]; then
        css_class="powersaver"
    elif [ "$profile" = "balanced" ]; then
        css_class="balanced"
    fi
    
    # agregar clase adicional basada en el estado de la batería
    if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
        css_class="$css_class charging"
    elif [ "$capacity" -le 15 ]; then
        css_class="$css_class critical"
    fi
    
    # limpiar espacios extras
    css_class=$(echo "$css_class" | xargs)
else
    # si no hay batería (desktop), no mostrar nada
    exit 0
fi

# salida en formato JSON para waybar
echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\", \"class\":\"$css_class\"}"
