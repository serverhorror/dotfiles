#!/bin/bash

set -o xtrace
set -o errexit

command -v hyprctl >/dev/null 2>&1 || {
    echo >&2 "hyprctl is required but it's not installed. Aborting."
    exit 1
}
command -v jq >/dev/null 2>&1 || {
    echo >&2 "jq is required but it's not installed. Aborting."
    exit 1
}

hyprctl dispatch togglefloating

is_floating="$(hyprctl -j activewindow | jq '.floating == true')"

# winows *was* tiled and is *now floating*
if [ "$is_floating" == "true" ]; then
    hyprctl dispatch resizeactive exact 2540 1440
    hyprctl dispatch centerwindow
fi
