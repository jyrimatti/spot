#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-24.05-small -p sqlite getoptions coreutils jq miller
set -eu

DB="${DB:-./spot.db}"

TZ='Europe/Helsinki'
TAX='null'

. ./util.sh

parser() {
  msg -- "Returns electricity tax in Finland" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   TZ     -t --tz  init:=$TZ                      -- "Output time zone (default: $TZ)"
  param   TAX    -x --tax init:=$TAX validate:percentage -- "Included VAT percent (0-100) (default: VAT at specific time)"
  disp    :usage -h --help
}

eval "$(getoptions parser) exit 1"

if [ $# != 0 ]; then usage; exit 1; fi

export TZ
tax="SELECT 1 + percent/100.0 FROM (SELECT coalesce($TAX, percent) percent FROM transfervat v WHERE v.start >= t.start AND v.start < t.end)"

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') "$DB" '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%SZ', start, 'unixepoch') startTime,
           strftime('%Y-%m-%dT%H:%M:%SZ', end, 'unixepoch') endTime,
           ($tax) * centsPerKWh / (SELECT 1 + percent/100.0 FROM (SELECT percent FROM transfervat v WHERE v.start >= t.start AND v.start < t.end)) centsPerKWh
    FROM electricitytax t
    ORDER BY start" | formatJson
