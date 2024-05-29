#! /usr/bin/env nix-shell
#! nix-shell --pure --keep LD_LIBRARY_PATH -I channel:nixos-23.05-small -i dash -p dash nodejs
set -eu

./node_modules/.bin/webpack --mode=production
