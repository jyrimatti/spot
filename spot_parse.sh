#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-23.05-small -i bash -p jq yq gnugrep
set -eu

xq 'select(.Publication_MarketDocument) | .Publication_MarketDocument.TimeSeries[].Period | .timeInterval.start as $START | .Point | map({instant:$START, deltaHours:(.position | tonumber | .-1), centsPerKWh: (."price.amount" | tonumber | .*100/1000)})' | jq -s add | grep -v 'null'
