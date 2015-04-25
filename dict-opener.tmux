#!/bin/bash

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

source "${CURRENT_DIR}/scripts/helpers.sh"

default_open_key="d"
open_option="@dict-opener"

command_exists() {
    local command="$1"

    type "$command" >/dev/null 2>&1
}

is_osx() {
    local platform="$(uname)"

    [[ "$platform" == "Darwin" ]]
}

command_generator() {
    local command_string="$1"

    echo "xargs -I {} tmux run-shell 'cd #{pane_current_path}; $command_string dict://\"{}\" > /dev/null'"
}

generate_open_command() {
    if is_osx; then
        echo "$(command_generator "open")"
    elif command_exists "xdg-open"; then
        echo "$(command_generator "xdg-open")"
    else
        # error command for Linux machines when 'xdg-open' not installed
        ${CURRENT_DIR}/scripts/tmux_open_error_message.sh "xdg-open"
    fi
}

set_copy_mode_open_bindings() {
    local open_command="$(generate_open_command)"
    local key_bindings=$(get_tmux_option "$open_option" "$default_open_key")
    local key
    for key in $key_bindings; do
        tmux bind-key -t vi-copy    "$key" copy-pipe "$open_command"
        tmux bind-key -t emacs-copy "$key" copy-pipe "$open_command"
    done
}

set_copy_mode_open_bindings
