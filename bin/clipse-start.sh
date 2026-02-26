#!/bin/bash
# inicia el daemon de clipse si no está corriendo
pgrep -x clipse > /dev/null || nohup clipse -listen-shell > /dev/null 2>&1 &
