#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-24.05-small -i dash -p jq sqlite gnused
set -eu

# The data is always in UTC
export TZ=UTC

jq -r 'map([.instant, .deltaHours, .centsPerKWh]) | .[] | @csv' |
sed -e "s/\"\([^,]*\)\",\(.*\),\(.*\)/INSERT OR REPLACE INTO spot(instant,centsPerKWh) VALUES (strftime('%s', datetime('\1', 'utc', '+\2 hours')), \3);/" |
sqlite3 spot.db