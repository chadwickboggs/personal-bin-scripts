#!/usr/bin/env bash

grep_excludes=$(cat "${HOME}/stuff/grep_excludes_v.txt")

lsargs=''
folders=$(find ${lsargs} -mindepth 1 -maxdepth 1 -type d | grep -v "${grep_excludes}")
be_quiet=false
dry_run=false

USAGE="$(basename $0) <options> \n
\n
\t      Run the specified command through \"ls [lsargs] | parallel <specified command>\". \n
\n
\t      Options \n
\n
\t\t            [-h|--help]\t	This message gets printed only. \n
\t\t            [-a|--lsargs]\t	The arguments to pass to \"ls\" command.  Default: \"${lsargs}\" \n
\t\t            [-f|--folders]\t	The folders to use.  Default: \"${folders}\" \n
\t\t            [-q|--quiet]\t	Be quiet. \n
\t\t            [-n|--dryrun]\t	Do a dry run (do not execute). \n
"

args=$(getopt -o "hqna:f:" -l "help,quiet,dryrun,lsargs,folders" -- "$@")
eval set -- "$args"
while true; do
  case "$1" in
        -h | --help)	echo -e ${USAGE}; exit;;
		-a | --lsargs)	shift; lsargs="$1"; shift;;
		-f | --folders)	shift; folders="$1"; shift;;
        -q | --quiet)	be_quiet=true; shift;;
        -n | --dryrun)	dry_run=true; shift;;
        --) shift; break;;
        *) echo "Internal error!"; exit 1;;
  esac
done

#folders=$(echo ${folders} | tr '\n' ' ')

#ls --color=never -d ${lsargs} | parallel "$*"
cmd="echo \"${folders}\" | parallel \"$*\""

[[ ${be_quiet} == false ]] && echo "	Executing \"$(echo ${cmd} | tr '\n' ' ')\""
[[ ${dry_run} == true ]] && exit

bash -c "${cmd}"

exit $?

