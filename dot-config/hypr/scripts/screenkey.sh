#!/bin/bash

set -o xtrace
set -o errexit

command -v screenkey >/dev/null 2>&1 || {
    echo >&2 "screenkey is required but it's not installed. Aborting."
    exit 1
}

hyprctl dispatch exec "screenkey --start-disabled"
