#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-24.05-small -i dash -p dash sqlite
set -eu

echo 'create table spot (instant INTEGER PRIMARY KEY, centsPerKWh REAL NOT NULL);' | sqlite3 spot.db
