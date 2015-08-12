#!/usr/bin/env bash
#
# Log <type> <msg>
#
log() {
  printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" $1 $2
}

#
# Exit with the given <msg ...>
#
abort() {
  printf "\n  \033[31mError: $@\033[0m\n\n" && exit 1
}

#
# Hide cursor.
#
hide_cursor() {
  printf "\e[?25l"
}

#
# Show cursor.
#
show_cursor() {
  printf "\e[?25h"
}

#
# Get process list
#

process_list() {
  ps aux | grep $1 | awk '{printf "%s--%s--%s\n", $1, $2, $12}'
}

#
# Display processes
#
display_process_with_selected() {
  processList=$(process_list $1)
  i=0
  echo
  for process in $processList; do
    if test $i -eq 0; then
      printf "  \033[36mo\033[0m $process\033[0m\n"
    else
      printf "   \033[90m $process\033[0m\n"
    fi
    i=$((i+1))
  done
  echo
}

display_process_with_selected $1