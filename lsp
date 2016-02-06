#!/usr/bin/env bash

lsargs='*'

help() {
  echo "
	$(basename $0) [-a <arguments to ls>] <command>
  
		-a : The argument to pass to 'ls'.  Default: \"${lsargs}\""
}

args=`getopt -o "ha:" -l "help,lsargs" -- "$@"`
eval set -- "$args"
while true; do
  case "$1" in
		-h | --help) shift; help; exit 0;;
		-a | --lsargs) shift; lsargs="$1"; shift;;
		--) shift; break;;
		*) echo "Internal error!"; exit 1;;
  esac
done

ls --color=never -d ${lsargs} | parallel $@

exit $?
