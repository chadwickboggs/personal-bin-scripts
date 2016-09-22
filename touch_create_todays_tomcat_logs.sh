#!/usr/bin/env bash

yesterday=$(date '+%Y-%m-%d' -d 'yesterday')
today=$(date '+%Y-%m-%d')

ls *.${yesterday}.log | parallel "echo touch $(echo -n {} | sed s/${yesterday}/${today}/); echo rmv {}"

