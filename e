#!/usr/bin/env bash

if [ -n "$1" ]; then
	skip=$1
else
	skip=1
fi

for ((i=0; i<${skip}; i++)); do
	echo
done

exit $?
