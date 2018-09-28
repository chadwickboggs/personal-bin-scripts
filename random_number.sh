#!/usr/bin/env bash

tr -dc 'a-f0-9' < /dev/urandom | head -c32

exit $?

