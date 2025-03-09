#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash jq gnugrep
set -eu

jq 'map({instant:(.timestamp | strftime("%Y-%m-%dT%H:%M:%SZ")), deltaHours:0, centsPerKWh: (.price | .*100 | round/1000)})' | jq -s add | grep -v 'null'
