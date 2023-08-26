#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -I channel:nixos-23.05-small -p bash nix jq
set -eu

./current.sh | jq '.centsPerKWh'
