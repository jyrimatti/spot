#! /usr/bin/env nix-shell
#! nix-shell -I channel:nixos-22.11-small -i bash -p jq sqlite
set -eu

jq -r 'map([.instant, .centsPerKWh]) | .[] | @csv' |
(sqlite3 -csv spot.db ".import '|cat -' spot" || true)