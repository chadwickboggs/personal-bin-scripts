#!/usr/bin/env bash

ls $@ | parallel 'echo -n "" > "{}"'

echo $?
