#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash jq yq gnugrep
set -eu

xq --xml-force-list TimeSeries --xml-force-list Period 'select(.Publication_MarketDocument) | .Publication_MarketDocument.TimeSeries[].Period[] | .timeInterval.start as $START | .Point | map({instant:$START, deltaHours:(.position | tonumber | .-1), centsPerKWh: (."price.amount" | tonumber | .*100/1000)})' | jq -s add | grep -v 'null'
