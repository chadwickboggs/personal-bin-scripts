#!/usr/bin/env bash

git branch|sed 's/^ *//'|grep -v master|tac|while read x; do git checkout $x;git pull --all;done

exit $?
