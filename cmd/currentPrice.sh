#! /usr/bin/env nix-shell
#! nix-shell --pure --keep LD_LIBRARY_PATH -i dash -I channel:nixos-23.11-small -p dash cacert curl gnused
set -eu

printf %.3f "$(curl -s https://spot.lahteenmaki.net/current.csv | sed 's/.*,//g')"
