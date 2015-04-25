#!/bin/bash

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

source "${CURRENT_DIR}/helpers.sh"

MISSING_PROGRAM="$1"

display_message "tmux-open error! Please make sure '$MISSING_PROGRAM' is installed."