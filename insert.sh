#! /usr/bin/env nix-shell
#! nix-shell -I channel:nixos-22.11-small -i bash -p jq sqlite
set -eu

# The current data is always in CET...
export TZ=Europe/Brussels

jq -r 'map([.instant, .centsPerKWh]) | .[] | @csv' |
sed -e "s/\"\([^,]*\)\",\(.*\)/INSERT OR REPLACE INTO spot(instant,centsPerKWh) VALUES (strftime('%s', datetime('\1', 'utc')), \2);/" |
sqlite3 spot.db