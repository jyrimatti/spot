#! /usr/bin/env nix-shell
#! nix-shell -I channel:nixos-22.11-small -i bash -p curl
set -eu

year=$1
month=$2
day=$3

curl "https://www.nordpoolgroup.com/api/marketdata/page/35?currency=EUR&endDate=$day-$month-$year"