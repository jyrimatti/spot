#! /usr/bin/env nix-shell
#! nix-shell -i bash -I channel:nixos-23.05-small -p sqlite getoptions
set -eu

NIGHT_DELTA=0
NIGHT_START=22
NIGHT_END=7
FROM=$(date -u +%Y-%m-%d'T'%H:%M:%S'Z')
TZ='Europe/Helsinki'

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
  disp    :usage      -h --help
}
natural() { case $OPTARG in (*[!0-9]*) return 1; esac; }
number() { case $OPTARG in (*[!0-9.-]*) return 1; esac; }
isoDateTime() {
    if ! [[ "$OPTARG" =~ ^[0-9]*-[0-9]*-[0-9]*(T[0-9]*(:[0-9]*(:[0-9]*)?)?[-+Z0-9:]*)?$ ]]; then
        return 1
    fi
}
eval "$(getoptions parser) exit 1"

if (( $# != 0 )); then usage; exit 1; fi
if [[ -z $WINDOW ]]; then usage; exit 1; fi

export TZ
offset=$(date +%:z)

$(command -v sqlite3 || echo '/run/current-system/sw/bin/sqlite3') ./spot.db '.mode json' "
    SELECT strftime('%Y-%m-%dT%H:%M:%S${offset}', instant, 'unixepoch', 'localtime') startTime, average centsPerKWh
    FROM (SELECT instant, centsPerKWh, AVG(CASE WHEN CAST(strftime('%H', instant, 'unixepoch') AS NUMERIC) BETWEEN $NIGHT_END AND $NIGHT_START THEN centsPerKWh ELSE centsPerKWh+($NIGHT_DELTA) END) OVER win average, COUNT(*) OVER win rows
        FROM spot
        WHERE instant >= strftime('%s', '$FROM')
        WINDOW win AS (ORDER BY instant ROWS between CURRENT ROW AND $WINDOW-1 FOLLOWING))
    WHERE rows = $WINDOW
    ORDER BY average"
