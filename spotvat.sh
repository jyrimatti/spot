#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-23.05-small -p sqlite getoptions coreutils jq miller
set -eu

DB="${DB:-./spot.db}"

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

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') "$DB" '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%SZ', start, 'unixepoch') startTime,
           strftime('%Y-%m-%dT%H:%M:%SZ', end, 'unixepoch') endTime,
           percent
    FROM spotvat
    ORDER BY start" | formatJson
