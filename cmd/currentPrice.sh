#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.05-small -p nix jq
set -eu

./current.sh | jq '.centsPerKWh'
