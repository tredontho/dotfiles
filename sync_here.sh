#!/bin/sh
find . -type f -not -path "./.git/*" | sed 's/\.\//\//g' | rsync -v --files-from=- / .
