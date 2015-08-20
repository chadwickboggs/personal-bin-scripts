#!/usr/bin/env bash

excludes="grep -v '\/business\/'|grep -v '\/web\/'|grep -v '\/tmp\/'|grep -v '\/run\/'"

if [[ $# == 2 && $1 == '-a' ]]; then
	lsp -a "$2" "find "$2/{/}" -name \'*-SNAPSHOT.jar\' | ${excludes}"
	exit
fi

lsp "find {/} -name \'*-SNAPSHOT.jar\' | ${excludes}"

exit $?
