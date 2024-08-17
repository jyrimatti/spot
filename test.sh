#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-unstable -p cached-nix-shell
#! nix-shell -i dash -I channel:nixos-24.05-small -p dash nix shellspec sqlite miller jq
. ./prelude
set -eu

prefix="${1:-}"

cached-nix-shell --wrap shellspec --shell dash --fail-fast --format documentation spec/$prefix*