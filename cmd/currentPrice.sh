#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -i dash -I channel:nixos-24.05-small -p dash cacert curl gnused
set -eu

printf %.3f "$(curl -s https://spot.lahteenmaki.net/current.csv | tail -n1 | sed 's/.*,//g')"
