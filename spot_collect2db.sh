#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY -I channel:nixos-23.11-small -i dash -p dash
set -eu

. ./spot_env.sh

./spot_load.sh | ./spot_parse.sh | ./spot_insert.sh