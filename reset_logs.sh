#!/usr/bin/env bash

mkdir backups
ls *.log | while read x;do reset_file.sh $x; mv *-bak* backups/.;done

