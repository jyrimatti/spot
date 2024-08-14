#!/bin/sh

urldecode() {
    echo "$1" | sed 'y/+/ /; s/%/\\x/g'
}

read_querystring() {
    q="$(urldecode "$QUERY_STRING")"
    saveIFS="$IFS"
    IFS='&'
    for f in $q; do
        value="${f##*=}"
        key="${f%%=*}"
        eval "qs_$key='$value'"
    done
    IFS="$saveIFS"
}

getParameters() {
    urldecode "$QUERY_STRING" | sed 's/&/ --/g' | sed 's/^/--/'
}

percentage() {
  case $OPTARG in ''|*[!0-9]*) return 1 ;; esac
  if [ "$OPTARG" -lt 0 ] || [ "$OPTARG" -gt 100 ] ; then return 1; fi
}

natural() { case $OPTARG in (*[!0-9]*) return 1 ;; esac; }
integer() { case "${OPTARG#[+-]}" in ''|*[!0-9]*) return 1 ;; esac; }
number() { case $OPTARG in (*[!0-9.-]*) return 1 ;; esac; }

isoDate() {
    echo "$OPTARG" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
}

isoDateTime() {
    echo "$OPTARG" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(Z|[+-][0-9]{2}:[0-9]{2})$'
}