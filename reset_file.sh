#!/usr/bin/env bash

if [[ -z $* ]]; then
  echo "You must provide the filename of the file you wish to reset."
  exit 1
fi

filename=$1

cp -v ${filename} ${filename}-bak.$(now)
echo -n '' > ${filename}
