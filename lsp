#!/usr/bin/env bash

help() {
  echo "
	$(basename $0) [-a <arguments to ls>] <command>
  
		-a : The argument to pass to 'ls'."
}

lsargs='*'

args=`getopt -o ha: -- "$@"`
eval set -- "$args"
while true; do
  case "$1" in
		-h) shift; help; exit 0;;
		-a) shift; lsargs="$1"; shift;;
		--) shift; break;;
		*) echo "Internal error!"; exit 1;;
  esac
done

ls --color=never -d ${lsargs} | parallel "$*"

exit $?
