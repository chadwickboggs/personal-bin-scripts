#!/bin/bash

sudo nice port selfupdate
sudo nice port upgrade outdated
#sudo nice port upgrade installed

sudo nice fink -qy selfupdate
sudo nice fink -qy update-all

sudo nice gem1.9 update

exit $?
