#!/usr/bin/env bash

echo "Executing: \"port selfupdate\""
port selfupdate
rtn_code=$?

echo
echo "Executing: \"port upgrade outdated\""
port -RNp upgrade outdated
rtn_code=$((${rtn_code} + $?))

#fink -qy selfupdate
#fink -qy selfupdate-rsync
#fink -qy update-all
#fink -qy index -f

echo
echo "Executing: \"gem update\""
gem update
rtn_code=$((${rtn_code} + $?))

echo
echo "Executing: \"npm upgrade\""
npm upgrade
rtn_code=$((${rtn_code} + $?))

exit ${rtn_code}

