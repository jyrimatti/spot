#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-24.05-small -p sqlite getoptions coreutils
set -eu

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
offset=$(date +%:z)
tax="SELECT 1 + percent/100.0 FROM (SELECT coalesce($TAX, percent) percent FROM transfervat WHERE unixepoch() BETWEEN start AND end)"

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', start, 'unixepoch', 'localtime') startTime,
           strftime('%Y-%m-%dT%H:%M:%S${offset}', end, 'unixepoch', 'localtime') endTime,
           ($tax) * centsPerKWh / (SELECT 1 + percent/100 FROM (SELECT percent FROM transfervat WHERE unixepoch() BETWEEN start AND end)) centsPerKWh
    FROM electricitytax
    ORDER BY start"
