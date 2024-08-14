#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-24.05-small -p dash cacert curl gnused
set -eu

printf %.3f "$(curl -s https://spot.lahteenmaki.net/current.csv | sed 's/.*,//g')"
