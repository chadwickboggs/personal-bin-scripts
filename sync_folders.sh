#!/usr/bin/env bash

script_home=$(dirname $0)
now=$(${script_home}/now)

echo "[${now}] Syncing folders..."

${script_home}/rsync_cp -v ~/Dropbox/charter ~/google_drive
${script_home}/rsync_cp -v ~/google_drive/charter ~/Dropbox

${script_home}/rsync_cp -v ~/Dropbox/charter ~/ownCloud
${script_home}/rsync_cp -v ~/Dropbox/charter ~/amazon_cloud_drive

echo "[${now}] Done syncing folders."
