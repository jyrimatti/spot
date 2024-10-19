#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY -I channel:nixos-24.05-small -i dash -p dash nix
set -eu

. ./spot_env.sh

./spot_load.sh | ./spot_parse.sh | ./spot_insert.sh | ./spot_add_missing.sh