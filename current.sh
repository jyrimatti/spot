#!/bin/sh

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export TZ=Europe/Brussels
now=$(date +%Y-%m-%d' '%H:%M:%S)

echo 'Content-type: text/plain'
echo ''
/run/current-system/sw/bin/sqlite3 $scripts/spot.db "select * from spot where instant <= '$now' order by instant desc limit 1"
