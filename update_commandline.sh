#!/usr/bin/env bash

sudo nice port selfupdate
sudo nice port upgrade outdated
#sudo nice port upgrade installed

#sudo nice fink -qy selfupdate
#sudo nice fink -qy update-all

sudo nice gem2.1 update

exit $?
