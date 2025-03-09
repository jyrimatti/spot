#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash jq sqlite gnused
set -eu

# The data is always in UTC
export TZ=UTC

jq -r 'map([.instant, .deltaHours, .centsPerKWh]) | .[] | @csv'\
  | sed -e "s/\"\([^,]*\)\",\(.*\),\(.*\)/INSERT INTO spot(instant,centsPerKWh) SELECT strftime('%s', datetime('\1', 'utc', '+\2 hours')), \3 WHERE strftime('%s', datetime('\1', 'utc', '+\2 hours')) NOT IN (SELECT instant FROM spot WHERE centsPerKWh IS NOT NULL);/" \
  | sqlite3 spot.db