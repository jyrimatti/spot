#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-24.05-small -p sqlite getoptions coreutils jq miller
set -eu

DB="${DB:-./spot.db}"

TZ='Europe/Helsinki'
TAX='null'

. ./util.sh

parser() {
  msg -- "Returns the spot prices for a given day" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   DAY    -d --day            validate:isoDate    -- "The day (yyyy-MM-dd) (required)"
  param   TZ     -t --tz  init:=$TZ                      -- "Output time zone (default: $TZ)"
  param   TAX    -x --tax init:=$TAX validate:percentage -- "Included VAT percent (0-100) (default: VAT at specific time)"
  disp    :usage -h --help
}

eval "$(getoptions parser) exit 1"

if [ $# != 0 ]; then usage; exit 1; fi
if [ -z "$DAY" ]; then usage; exit 1; fi

export TZ
tax="SELECT 1 + percent/100.0 FROM (SELECT coalesce($TAX, percent) percent FROM spotvat WHERE instant >= start AND instant < end)"

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') "$DB" '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%SZ', instant, 'unixepoch') startTime,
           centsPerKWh * CASE WHEN centsPerKWh > 0 THEN ($tax) ELSE 1 END centsPerKWh
    FROM spot
    WHERE strftime('%Y-%m-%d', instant, 'unixepoch', 'localtime') = '$DAY'
    ORDER BY instant" | formatJson
