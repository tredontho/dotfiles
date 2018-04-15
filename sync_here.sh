#!/bin/sh
find . -type f -not -name "sync_here.sh" -not -path "./.git/*" | sed 's/\.\//\//g' | rsync -v --files-from=- / .
