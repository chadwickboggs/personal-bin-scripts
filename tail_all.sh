#!/bin/bash

name='*.log'
if [ -n "$1" ]; then
	name=$1
fi

lspf "{}" -name "${name}" | sed 's/^/-f /' | xargs tail

exit $?
