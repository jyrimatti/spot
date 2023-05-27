#! /usr/bin/env nix-shell
#! nix-shell -I channel:nixos-22.11-small -i bash -p sqlite
set -eu

echo 'create table spot (instant TEXT PRIMARY KEY, centsPerKWh REAL NOT NULL);' | sqlite3 spot.db
