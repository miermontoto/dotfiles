#!/bin/bash

df / | awk 'NR==2 {print $5}' | tr -d '%'
