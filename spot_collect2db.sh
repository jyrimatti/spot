#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash nix
set -eu

. ./spot_env.sh

#entsoe
./spot_load_entsoe.sh | ./spot_parse_entsoe.sh | ./spot_insert.sh

#elering
./spot_load_elering.sh | ./spot_parse_elering.sh | ./spot_insert.sh

./spot_add_missing.sh