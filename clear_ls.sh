#!/usr/bin/env bash

ls $* | parallel 'echo "" > "{}"'

echo $?
