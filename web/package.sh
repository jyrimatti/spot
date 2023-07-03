#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-23.05-small -i bash -p nodejs
set -eu

./node_modules/.bin/webpack --mode=production
