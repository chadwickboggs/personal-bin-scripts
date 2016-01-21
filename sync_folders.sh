#!/usr/bin/env bash

script_home=$(dirname $0)

now=$(${script_home}/now)
echo "[${now}] Syncing folders..."

echo "	Synching each into Dropbox..."

${script_home}/rsync_cp -v ~/own_cloud/charter 				~/Dropbox
${script_home}/rsync_cp -v ~/google_drive/charter 			~/Dropbox
${script_home}/rsync_cp -v ~/amazon_cloud_drive/charter 	~/Dropbox
${script_home}/rsync_cp -v ~/icloud/charter 				~/Dropbox

echo "	Done synching each into Dropbox."
echo "	Synching Dropbox out to each..."

${script_home}/rsync_cp -v ~/Dropbox/charter 	~/own_cloud
${script_home}/rsync_cp -v ~/Dropbox/charter 	~/google_drive
${script_home}/rsync_cp -v ~/Dropbox/charter 	~/amazon_cloud_drive
${script_home}/rsync_cp -v ~/Dropbox/charter 	~/icloud

echo "	Done synching Dropbox out to each."

now=$(${script_home}/now)
echo "[${now}] Done syncing folders."
