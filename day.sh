#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-23.05-small -p sqlite getoptions bc
set -eu

TZ='Europe/Helsinki'
TAX=0

parser() {
  msg -- "Returns the spot prices for a given day" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   DAY    -d --day            validate:isoDate    -- "The day (yyyy-MM-dd) (required)"
  param   TZ     -t --tz  init:=$TZ                      -- "Output time zone (default: $TZ)"
  param   TAX    -x --tax init:=$TAX validate:percentage -- "Included tax percent (0-100) (default: $TAX)"
  disp    :usage -h --help
}
isoDate() {
    echo "$OPTARG" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
}
percentage() {
  case $OPTARG in ''|*[!0-9]*) return 1 ;; esac
  if [ "$OPTARG" -lt 0 ] || [ "$OPTARG" -gt 100 ] ; then return 1; fi
}

eval "$(getoptions parser) exit 1"

if [ $# != 0 ]; then usage; exit 1; fi
if [ -z "$DAY" ]; then usage; exit 1; fi

export TZ
offset=$(date +%:z)
tax=$(echo "1 + $TAX/100" | bc -l)

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', instant, 'unixepoch', 'localtime') startTime, centsPerKWh*CASE WHEN centsPerKWh > 0 THEN $tax ELSE 1 END centsPerKWh
    FROM spot
    WHERE strftime('%Y-%m-%d', instant, 'unixepoch', 'localtime') = '$DAY'
    ORDER BY instant"
