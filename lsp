#!/usr/bin/env bash

help() {
  echo Options: -a  argument to pass to 'ls' command.
}

n=0
args=`getopt -o ha: -- "$@"`
eval set -- "$args"
while true; do
  case "$1" in
		-h) shift; help; exit 0;;
		-a) shift; lsargs="$1"; ((n++)); shift;;
		--) shift; break;;
		*) echo "Internal error!"; exit 1;;
  esac
done

cmd="ls ${lsargs} --color=never | parallel \"${*:n}\""
#echo cmd=$cmd;exit

bash -c "$cmd"

exit $?
