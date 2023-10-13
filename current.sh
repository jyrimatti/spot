#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-23.05-small -p sqlite getoptions bc coreutils
set -eu

TZ='Europe/Helsinki'
TAX=0

parser() {
  msg -- "Returns the current spot price" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   TZ     -t --tz  init:=$TZ                      -- "Output time zone (default: $TZ)"
  param   TAX    -x --tax init:=$TAX validate:percentage -- "Included tax percent (0-100) (default: $TAX)"
  disp    :usage -h --help
}
percentage() {
  case $OPTARG in ''|*[!0-9]*) return 1 ;; esac
  if [ "$OPTARG" -lt 0 ] || [ "$OPTARG" -gt 100 ] ; then return 1; fi
}

eval "$(getoptions parser) exit 1"

if [ $# != 0 ]; then usage; exit 1; fi

export TZ
now=$(date +%s)
offset=$(date +%:z)
tax=$(echo "1 + $TAX/100" | bc -l)

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', instant, 'unixepoch', 'localtime') startTime, centsPerKWh*CASE WHEN centsPerKWh > 0 THEN $tax ELSE 1 END centsPerKWh
    FROM spot
    WHERE instant <= '$now'
    ORDER BY instant DESC
    LIMIT 1" | sed 's/^\[//' | sed 's/\]$//'
