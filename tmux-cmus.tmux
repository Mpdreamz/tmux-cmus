#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key -n F8 run-shell "cmus-remote -u"
tmux bind-key -n F9 run-shell "cmus-remote -n"
tmux bind-key -n F7 run-shell "cmus-remote -r"

cmus_status_string="#($CURRENT_DIR/scripts/cmus.sh)"
cmus_status_interpolation_string="\#{cmus_status}"

source $CURRENT_DIR/scripts/shared.sh

do_interpolation() {
	local string="$1"
	local interpolated="${string/$cmus_status_interpolation_string/$cmus_status_string}"
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
