#!/usr/bin/env bash

# obtener workspaces de hyprland
workspaces=$(hyprctl workspaces -j)

# formatear output
echo "$workspaces" | jq -r '.[] | 
  if .id == (.name | tonumber // -1) then 
    .id | tostring
  else 
    (.id | tostring) + ": " + .name
  end' | tr '\n' ' '