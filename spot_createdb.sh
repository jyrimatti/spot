#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash sqlite
set -eu

sqlite3 spot.db < spot_create.sql
