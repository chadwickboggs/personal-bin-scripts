#!/usr/bin/env bash

script_home=$(dirname $0)

now=$(${script_home}/now)
echo "[${now}] Unisonizing folders..."

/opt/local/bin/unison $@

now=$(${script_home}/now)
echo "[${now}] Done unisonizing folders."

