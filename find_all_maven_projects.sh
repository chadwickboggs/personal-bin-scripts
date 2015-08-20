#!/usr/bin/env bash

lspf {} -name pom.xml | sed 's/\([^\/]*\)\/.*/\1/' | sort -ud

exit $?
