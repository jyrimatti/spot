#! /usr/bin/env nix-shell
#! nix-shell -i dash -I channel:nixos-24.05-small -p sqlite getoptions coreutils jq miller
set -eu

NIGHT_DELTA=0
NIGHT_START=22
NIGHT_END=7
FROM="$(date -u +%Y-%m-%d'T'%H:%M:%S'Z')"
TZ='Europe/Helsinki'
TAX='null'

DB="${DB:-./spot.db}"

. ./util.sh

parser() {
  msg -- "Returns the cheapest windows of given hours ordered by average cost" ''
  setup   REST error:usage help:usage -- "Usage:  $0 [options]..." ''
  msg -- 'Options:'
  param   WINDOW      -w --window     validate:natural                         -- "Number of hours in the window (required)"
  param   NIGHT_DELTA -d --nightDelta validate:number      init:=$NIGHT_DELTA  -- "Price difference of night hours (default: $NIGHT_DELTA)"
  param   NIGHT_START -s --nightStart validate:natural     init:=$NIGHT_START  -- "Hour of the beginning of night hours (default: $NIGHT_START)"
  param   NIGHT_END   -e --nightEnd   validate:natural     init:=$NIGHT_END    -- "Hour of the end of night hours (default: $NIGHT_END)"
  param   FROM        -f --from       validate:isoDateTime init:=$FROM         -- "Earliest start time of the window (default: now)"
  param   TZ          -t --tz                              init:=$TZ           -- "Output time zone (default: $TZ)"
  param   TAX         -x --tax        validate:percentage  init:=$TAX          -- "Included VAT percent (0-100) (default: VAT at specific time)"
  disp    :usage      -h --help
}

eval "$(getoptions parser) exit 1"

if [ $# != 0 ]; then usage; exit 1; fi
if [ -z "$WINDOW" ]; then usage; exit 1; fi

export TZ
tax="SELECT 1 + percent/100.0 FROM (SELECT coalesce($TAX, percent) percent FROM spotvat WHERE instant >= start AND instant < end)"

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') "$DB" '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%SZ', instant, 'unixepoch') startTime,
           average centsPerKWh
    FROM (
        SELECT instant,
               centsPerKWh,
               AVG(CASE WHEN CAST(strftime('%H', instant, 'unixepoch') AS NUMERIC) BETWEEN $NIGHT_END AND $NIGHT_START
                        THEN centsPerKWh
                        ELSE centsPerKWh+($NIGHT_DELTA)
                   END) OVER win average,
               COUNT(*) OVER win rows
        FROM (
            SELECT instant, centsPerKWh * CASE WHEN centsPerKWh > 0 THEN ($tax) ELSE 1 END centsPerKWh
            FROM spot
            WHERE instant >= strftime('%s', '$FROM')
        )
        WINDOW win AS (ORDER BY instant ROWS between CURRENT ROW AND $WINDOW-1 FOLLOWING)
    )
    WHERE rows = $WINDOW
    ORDER BY average" | formatJson
