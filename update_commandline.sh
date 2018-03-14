#!/usr/bin/env bash

pls nice port selfupdate
pls nice port upgrade outdated
#pls nice port upgrade installed

#pls nice fink -qy selfupdate
#pls nice fink -qy selfupdate-rsync
#pls nice fink -qy update-all
#pls nice fink -qy index -f

pls nice npm upgrade
pls nice gem update

exit $?
