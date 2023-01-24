echo "---" | tee -a /tmp/polybar.log
polybar mier 2>&1 | tee -a /tmp/polygar.log & disown
