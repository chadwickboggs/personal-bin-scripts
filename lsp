#!/usr/bin/env bash

lsargs=''

USAGE="$(basename $0) <options> \n
\n
\t      Run the specified command through \"ls [lsargs] | parallel <specified command>\". \n
\n
\t      Options \n
\n
\t\t            [-h|--help]\t	This message gets printed only. \n
\t\t            [-a|--lsargs]\t	The arguments to pass to \"ls\" command.  Default: \"${lsargs}\" \n
\t\t            [-q|--quiet]\t	Be quiet. \n
"

lsargs=''
be_quiet=false
grep_excludes_file="${HOME}/stuff/grep_excludes_for_lspf.txt"

args=`getopt -o "hqa:" -l "help,quiet,lsargs" -- "$@"`
eval set -- "$args"
while true; do
  case "$1" in
        -h | --help)	echo -e ${USAGE}; exit;;
		-a | --lsargs)	shift; lsargs="$1"; shift;;
        -q | --quiet)	be_quiet=true; shift;;
        --) shift; break;;
        *) echo "Internal error!"; exit 1;;
  esac
done

#ls --color=never -d ${lsargs} | parallel "$*"
find -mindepth 1 -maxdepth 1 -type d ${lsargs} | parallel "$*"

exit $?

