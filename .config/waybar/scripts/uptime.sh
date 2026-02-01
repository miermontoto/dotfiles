#!/bin/bash

# usa el mismo formato compacto que zellij
uptime_text=$(uptime -p | sed -e 's/up //' -e 's/ days\?/d/' -e 's/ hours\?/h/' -e 's/ minutes\?/m/' -e 's/ weeks\?/w/'  -e 's/ week\?/w/' -e 's/,//g' -e 's/ //g')

# salida en formato json para waybar
echo "{\"text\": \"$uptime_text\", \"class\": \"uptime\"}"