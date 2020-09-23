#!/usr/bin/env bash

echo "Selfupdating MacPorts..."
sudo port selfupdate
rtn_code=$?
echo "Done selfupdating MacPorts."

echo
echo "Updating MacPorts..."
sudo port -RNpu upgrade outdated
rtn_code=$((${rtn_code} + $?))
echo "Done updating MacPorts."

echo
echo "Updating Homebrew..."
brew upgrade
brew cleanup
rtn_code=$((${rtn_code} + $?))
echo "Done updating Homebrew."

#fink -qy selfupdate
#fink -qy selfupdate-rsync
#fink -qy update-all
#fink -qy index -f

#echo
#echo "Updating Gems..."
#gem update
#rtn_code=$((${rtn_code} + $?))
#echo "Done updating Gems."

#echo
#echo "Updating NPM..."
#npm upgrade
#rtn_code=$((${rtn_code} + $?))
#echo "Done updating NPM."

#echo
echo "Updating Fish Shell Completions..."
fish_update_completions
echo "Done updating Fish Shell Completins."

exit ${rtn_code}

