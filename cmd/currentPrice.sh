#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.05-small -p dash cacert curl gnused
set -eu

printf %.1f "$(curl -s https://spot.lahteenmaki.net/current.csv | sed 's/.*,//g')"
