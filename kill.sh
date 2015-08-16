#!/usr/bin/env bash

UP=$'\033[A'
DOWN=$'\033[B'


#
# Log <type> <msg>
#
log() {
  printf "  \e[0;32m%10s\033[0m : \033[0m%s\033[0m\n" $1 $2
}

#
# Exit with the given <msg ...>
#
abort() {
  printf "\n  \033[31mError: $@\033[0m\n\n" && exit 1
}


fullscreen_on() {
  tput smcup
  stty -echo
}

fullscreen_off() {
  tput rmcup
  stty echo
}

handle_sigint() {
  fullscreen_off
  exit $?
}

handle_sigtstp() {
  fullscreen_off
  kill -s SIGSTOP $$
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
  ps aux | grep $1 | awk '{printf "[%s]%s--%s ", $2, $1, $12}'
}

#
# Display processes
#
display_process_with_selected() {
  processList=($(process_list $1))
  killPos=${#processList[@]}
  exitPos=$((${#processList[@]}+1))
  if test $2 -gt $exitPos; then
    menuPosition=0
  else
    menuPosition=$2
  fi

  echo
  log "KillList" "$1"
  log "Porcesses" "${#processList[@]}"
  for process in ${!processList[@]}; do
    if test $process -eq $menuPosition; then
      printf "  \e[0;32mo <$process>\033[0m ${processList[$process]}\033[0m\n"
    else
      printf "    <$process>\033[90m ${processList[$process]}\033[0m\n"
    fi
  done

  if test $menuPosition -eq $killPos; then
    printf "   \e[0;32m Kill all\033[0m\n"
  else
    printf "   \033[90m Kill all\033[0m\n"
  fi

  if test $menuPosition -eq $exitPos; then
    printf "   \e[0;32m exit\033[0m\n"
  else
    printf "   \033[90m exit\033[0m\n"
  fi

  echo
}

#
# Do the list item action
#

#@TODO - kill # process, kill all processes or exit
activate_list_item() {
    clear
    printf "position %s \n" $1
    printf "Item %s \n" ${processList[$1]}
    printf "Length %s \n" ${#processList[@]}
#    fullscreen_off
}

#
# Display select list of processes and options for process of name $1
#

display_list() {
    fullscreen_on
    position = 0
    clear
    display_process_with_selected $1 0

    trap handle_sigint INT
    trap handle_sigtstp SIGTSTP
#@TODO - add scrolling limits - make it able to select kill all and exit
    while true; do
        read -n 3 c
        case "$c" in
          $UP)
            clear
            position=$((position-1))
            display_process_with_selected $1 $position
            ;;
          $DOWN)
            clear
            position=$((position+1))
            display_process_with_selected $1 $position
            ;;
          *)
            activate_list_item $position
#            fullscreen_off
            exit
            ;;
        esac
      done

}

#display_process_with_selected $1 $2

display_list $1