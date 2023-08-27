#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-23.05-small -p sqlite getoptions
set -eu

TZ='Europe/Helsinki'

parser() {
  msg -- "Returns the current spot price" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   TZ     -t --tz init:=$TZ         -- "Output time zone (default: $TZ)"
  disp    :usage -h --help
}

eval "$(getoptions parser) exit 1"

if (( $# != 0 )); then usage; exit 1; fi

export TZ
now=$(date +%s)
offset=$(date +%:z)

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', instant, 'unixepoch', 'localtime') startTime, centsPerKWh
    FROM spot
    WHERE instant <= '$now'
    ORDER BY instant DESC
    LIMIT 1" | sed 's/^\[//' | sed 's/\]$//'
