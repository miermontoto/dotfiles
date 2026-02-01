#!/bin/bash

# diagnóstico completo de red estilo WhyFi
get_wifi_info() {
    local wifi_device=$(nmcli -t -f DEVICE,TYPE device | grep wifi | head -1 | cut -d: -f1)

    if [ -z "$wifi_device" ]; then
        echo '{"text": "󰤭", "tooltip": "No WiFi device", "class": "disconnected"}'
        exit 0
    fi

    local connection=$(nmcli -t -f NAME,TYPE connection show --active | grep wireless | cut -d: -f1)

    if [ -z "$connection" ]; then
        echo '{"text": "󰤭", "tooltip": "Disconnected", "class": "disconnected"}'
        exit 0
    fi

    # datos básicos de conexión
    local ssid=$(nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d: -f2)
    local signal=$(nmcli -t -f active,signal dev wifi | grep "^yes" | cut -d: -f2)
    local freq=$(nmcli -t -f active,freq dev wifi | grep "^yes" | cut -d: -f2)
    local rate=$(nmcli -t -f active,rate dev wifi | grep "^yes" | cut -d: -f2)
    local ip=$(nmcli -t -f IP4.ADDRESS dev show "$wifi_device" | head -1 | cut -d: -f2 | cut -d/ -f1)
    local gateway=$(nmcli -t -f IP4.GATEWAY dev show "$wifi_device" | head -1 | cut -d: -f2)
    local dns=$(nmcli -t -f IP4.DNS dev show "$wifi_device" | head -1 | cut -d: -f2)

    # señal en dBm usando iw
    local signal_dbm=$(iw dev "$wifi_device" link 2>/dev/null | grep "signal:" | awk '{print $2}')
    local tx_bitrate=$(iw dev "$wifi_device" link 2>/dev/null | grep "tx bitrate:" | sed 's/.*tx bitrate: //')

    # determinar banda
    local band="2.4 GHz"
    if [ -n "$freq" ]; then
        local freq_num=$(echo "$freq" | grep -oP '\d+' | head -1)
        if [ "$freq_num" -gt 4000 ]; then
            band="5 GHz"
        fi
    fi

    # icono basado en señal
    local icon="󰤯"
    if [ -n "$signal" ]; then
        if [ "$signal" -ge 80 ]; then
            icon="󰤨"
        elif [ "$signal" -ge 60 ]; then
            icon="󰤥"
        elif [ "$signal" -ge 40 ]; then
            icon="󰤢"
        elif [ "$signal" -ge 20 ]; then
            icon="󰤟"
        fi
    fi

    # clase css
    local class="good"
    if [ -n "$signal" ]; then
        if [ "$signal" -lt 40 ]; then
            class="weak"
        elif [ "$signal" -lt 60 ]; then
            class="medium"
        fi
    fi

    # función para calcular ping stats (ping, jitter, loss)
    calc_ping_stats() {
        local host=$1
        local count=4
        local result=$(ping -c $count -W 1 "$host" 2>/dev/null)

        if [ -z "$result" ]; then
            echo "N/A|N/A|100"
            return
        fi

        # extraer tiempos individuales
        local times=$(echo "$result" | grep "time=" | sed 's/.*time=\([0-9.]*\).*/\1/')
        local loss=$(echo "$result" | grep -oP '\d+(?=% packet loss)' || echo "100")

        if [ -z "$times" ]; then
            echo "N/A|N/A|100"
            return
        fi

        # calcular promedio y jitter
        local sum=0
        local count_times=0
        local values=()

        while read -r t; do
            values+=("$t")
            sum=$(echo "$sum + $t" | bc)
            ((count_times++))
        done <<< "$times"

        if [ $count_times -eq 0 ]; then
            echo "N/A|N/A|$loss"
            return
        fi

        local avg=$(echo "scale=1; $sum / $count_times" | bc)

        # calcular jitter (desviación estándar)
        local sq_diff_sum=0
        for t in "${values[@]}"; do
            local diff=$(echo "$t - $avg" | bc)
            local sq_diff=$(echo "$diff * $diff" | bc)
            sq_diff_sum=$(echo "$sq_diff_sum + $sq_diff" | bc)
        done
        local jitter=$(echo "scale=1; sqrt($sq_diff_sum / $count_times)" | bc 2>/dev/null || echo "0")

        echo "$avg|$jitter|$loss"
    }

    # router stats
    local router_stats="N/A|N/A|N/A"
    if [ -n "$gateway" ]; then
        router_stats=$(calc_ping_stats "$gateway")
    fi
    local router_ping=$(echo "$router_stats" | cut -d'|' -f1)
    local router_jitter=$(echo "$router_stats" | cut -d'|' -f2)
    local router_loss=$(echo "$router_stats" | cut -d'|' -f3)

    # internet stats (cloudflare)
    local internet_stats=$(calc_ping_stats "1.1.1.1")
    local internet_ping=$(echo "$internet_stats" | cut -d'|' -f1)
    local internet_jitter=$(echo "$internet_stats" | cut -d'|' -f2)
    local internet_loss=$(echo "$internet_stats" | cut -d'|' -f3)

    # dns lookup time
    local dns_lookup="N/A"
    if command -v dig &>/dev/null && [ -n "$dns" ]; then
        local dns_time=$(dig @"$dns" google.com +time=1 +tries=1 2>/dev/null | grep "Query time:" | awk '{print $4}')
        if [ -n "$dns_time" ]; then
            dns_lookup="${dns_time} ms"
        fi
    fi

    # construir tooltip con secciones estilo WhyFi
    local tooltip="<b>● $ssid</b>  <span color='#888'>$band</span>\\n"
    tooltip+="\\n"
    tooltip+="<b>Link Rate</b>\\t<span color='#3498db'>${rate:-$tx_bitrate}</span>\\n"
    tooltip+="<b>Signal</b>\\t\\t<span color='#2ecc71'>${signal_dbm:-$signal} dBm</span>\\n"
    tooltip+="\\n"
    tooltip+="<b>Router</b> · $gateway\\n"
    tooltip+="  Ping\\t\\t<span color='#2ecc71'>${router_ping} ms</span>\\n"
    tooltip+="  Jitter\\t\\t<span color='#f39c12'>${router_jitter} ms</span>\\n"
    tooltip+="  Loss\\t\\t<span color='#e74c3c'>${router_loss}%</span>\\n"
    tooltip+="\\n"
    tooltip+="<b>Internet</b> · 1.1.1.1\\n"
    tooltip+="  Ping\\t\\t<span color='#2ecc71'>${internet_ping} ms</span>\\n"
    tooltip+="  Jitter\\t\\t<span color='#f39c12'>${internet_jitter} ms</span>\\n"
    tooltip+="  Loss\\t\\t<span color='#e74c3c'>${internet_loss}%</span>\\n"
    tooltip+="\\n"
    tooltip+="<b>DNS</b> · $dns\\n"
    tooltip+="  Lookup\\t<span color='#9b59b6'>${dns_lookup}</span>\\n"
    tooltip+="\\n"
    tooltip+="<span color='#888'>IP: $ip</span>"

    local text="$icon $ssid"

    echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
}

get_wifi_info
