#!/usr/bin/env bash

echo "Resetting outlook..."

defaults delete com.microsoft.Outlook
killall cfprefsd

echo "Outlook has been reset."

