#!/usr/bin/env bash
set -euo pipefail

MACHINES_DIR="$(cd "$(dirname "$0")" && pwd)"
HOSTNAME="$(hostname)"

if [ -d "$MACHINES_DIR/$HOSTNAME" ]; then
    TARGET="$HOSTNAME"
else
    echo "No profile found for '$HOSTNAME', using default"
    TARGET="default"
fi

ln -sfn "$MACHINES_DIR/$TARGET" "$MACHINES_DIR/current"
echo "Linked machines/current -> machines/$TARGET"
