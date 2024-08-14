#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-23.05-small -p sqlite getoptions coreutils jq
set -eu

TZ='Europe/Helsinki'

. ./util.sh

parser() {
  msg -- "Returns spot VAT in Finland" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   TZ     -t --tz  init:=$TZ -- "Output time zone (default: $TZ)"
  disp    :usage -h --help
}

eval "$(getoptions parser) exit 1"

if [ $# != 0 ]; then usage; exit 1; fi

export TZ
offset=$(date +%:z)

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', start, 'unixepoch', 'localtime') startTime,
           strftime('%Y-%m-%dT%H:%M:%S${offset}', end, 'unixepoch', 'localtime') endTime,
           percent||'' percent
    FROM spotvat
    ORDER BY start"\
  | jq -c 'map({startTime, endTime, percent: .percent | tonumber})'
