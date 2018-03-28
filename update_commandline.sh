#!/usr/bin/env bash

echo "	Executing \"port selfupdate\""
port selfupdate

echo "	Executing \"port upgrade outdated\""
port upgrade outdated

#port upgrade installed

#fink -qy selfupdate
#fink -qy selfupdate-rsync
#fink -qy update-all
#fink -qy index -f

echo "	Executing \"gem update\""
gem update

echo "	Executing \"npm upgrade\""
npm upgrade

exit $?
