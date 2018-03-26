#!/usr/bin/env bash

port selfupdate
port upgrade outdated
#port upgrade installed

#fink -qy selfupdate
#fink -qy selfupdate-rsync
#fink -qy update-all
#fink -qy index -f

gem update
npm upgrade

exit $?
