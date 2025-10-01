#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/.local/bin/poke-fetch"

if [[ -f "$TARGET" ]]; then
    rm "$TARGET"
    echo "Removed $TARGET, poke-fetch properly uninstalled."
else
    echo "poke-fetch not found in $TARGET, was it installed ?"
fi
