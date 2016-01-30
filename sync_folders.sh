#!/usr/bin/env bash

script_home=$(dirname $0)

sf_name='.'
declare -a folders=('.')

USAGE="$(basename $0) <options> <command line> \n
\n
\t	Copy the union the contents of the specified files into each of them, unionizing them. \n
\n
\t	Options \n
\n
\t\t		[-h|--help]\t\t\t\t		This message gets printed only. \n
\t\t		[-s|--subfolder]		<the subfolder>\t	The subfolder to unionize.  Default: \"${sf_name}\" \n
\t\t		command line			\t\t\t\t	The folders to unionize.  Default: \"${folders[@]}\" \n
"

args=`getopt -o "hs:" -l "help,subfolder" -- "$@"`
eval set -- "$args"
while true; do
  case "$1" in
		-h | --help)		echo -e ${USAGE};		exit;;
		-s | --subfolder)	shift; sf_name="$1";	shift;;
		--) shift; break;;
		*) echo "Internal error!"; exit 1;;
  esac
done

folders=($@)

#echo "sf_name=\"${sf_name}\""
#echo "folders=\"${folders[@]}\""
#exit

now=$(${script_home}/now)
echo "[${now}] Syncing folders..."

echo "	Synching each back into the first..."

for i in $(seq 1 $((${#folders[@]}-1))); do
	"${script_home}"/rsync_cp -v "${folders[$i]}/${sf_name}" "${folders[0]}"
done

echo "	Done synching each back into the first."
echo "	Synching the first out into each..."

for i in $(seq 1 $((${#folders[@]}-1))); do
	"${script_home}"/rsync_cp -v "${folders[0]}/${sf_name}" "${folders[$i]}"
done

echo "	Done synching the first out into each."

now=$(${script_home}/now)
echo "[${now}] Done syncing folders."
