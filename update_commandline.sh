#!/usr/bin/env bash

sudo nice port selfupdate
sudo nice port upgrade outdated
#sudo nice port upgrade installed

#sudo nice fink -qy selfupdate
#sudo nice fink -qy selfupdate-rsync
#sudo nice fink -qy update-all
#sudo nice fink -qy index -f

sudo nice npm upgrade
sudo nice gem update

exit $?
