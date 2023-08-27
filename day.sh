#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-23.05-small -p sqlite getoptions
set -eu

TZ='Europe/Helsinki'

parser() {
  msg -- "Returns the spot prices for a given day" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   DAY    -d --day validate:isoDate -- "The day (yyyy-MM-dd) (required)"
  param   TZ     -t --tz init:=$TZ         -- "Output time zone (default: $TZ)"
  disp    :usage -h --help
}
isoDate() {
    if ! [[ "$OPTARG" =~ ^[0-9]*-[0-9]*-[0-9]*$ ]]; then
        return 1
    fi
}

eval "$(getoptions parser) exit 1"

if (( $# != 0 )); then usage; exit 1; fi
if [[ -z $DAY ]]; then usage; exit 1; fi

export TZ
offset=$(date +%:z)

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', instant, 'unixepoch', 'localtime') startTime, centsPerKWh
    FROM spot
    WHERE strftime('%Y-%m-%d', instant, 'unixepoch', 'localtime') = '$DAY'
    ORDER BY instant"
