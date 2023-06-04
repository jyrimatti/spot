#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-22.11-small -i bash -p nodejs
set -eu

./node_modules/.bin/webpack --mode=production
