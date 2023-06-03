#!/bin/sh

# Returns the current spot price

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export TZ=Europe/Brussels
now=$(date +%Y-%m-%d' '%H:%M:%S)

echo 'Content-type: text/plain'
echo ''
/run/current-system/sw/bin/sqlite3 $scripts/spot.db "
    SELECT *
    FROM spot
    WHERE instant <= '$now'
    ORDER BY instant DESC
    LIMIT 1"
