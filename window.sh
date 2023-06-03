#!/bin/bash

# Returns the total cost for a window of given 'hours', starting from 'from' or the current time, ordered by total cost

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export TZ=Europe/Brussels

err() {
    if [ "$REQUEST_METHOD" != "" ];
    then
        echo "Status: 400 Bad Request"
        echo ""
    fi
    echo "$1" >&2
}

saveIFS=$IFS
IFS='=&'
parm=($QUERY_STRING)
IFS=$saveIFS

for ((i=0; i<${#parm[@]}; i+=2))
do
    declare "var_${parm[i]}=${parm[i+1]}"
done

if [ "$REQUEST_METHOD" != "" ];
then
echo 'Content-type: text/plain'
fi

# if query_string is empty, return the last hour
if [ "$QUERY_STRING" = "" ];
then
    err "Returns the total cost for a window of given 'hours', starting from 'from' or the current time, ordered by total cost."
    echo "Usage:" >&2
    echo " window.sh?hours=3" >&2
    echo " window.sh?hours=3&from=2023-06-03" >&2
    echo " window.sh?hours=3&from=2023-06-03 12:00" >&2
    exit 1
fi

if ! [[ "$var_hours" =~ ^[0-9]+$ ]] ; then
    err "error: Not a number: $var_hours"
    exit 1
fi
hours=$var_hours

from=${var_from:-$(date +%Y-%m-%d' '%H:%M:%S)}
if ! [[ "$from" =~ ^[0-9]*-[0-9]*-[0-9]*(' '[0-9]*(:[0-9]*(:[0-9]*)?)?)?$ ]] ; then
    err "error: Not a date/time: $var_from"
    exit 1
fi

echo ''
/run/current-system/sw/bin/sqlite3 $scripts/spot.db "
    SELECT instant, total
    FROM (SELECT instant, SUM(centsPerKWh) OVER win total, COUNT(*) OVER win rows
        FROM spot
        WHERE instant >= datetime('$from')
        WINDOW win AS (ORDER BY instant ROWS between CURRENT ROW AND $hours-1 FOLLOWING))
    WHERE rows = $hours
    ORDER BY total"
