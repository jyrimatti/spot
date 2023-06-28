#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-23.05-small -i bash -p curl cacert

if [ $# -eq 0 ];
then 
  curl "https://www.nordpoolgroup.com/api/marketdata/page/35?currency=EUR"
else
  year=$1
  month=$2
  day=$3
  curl "https://www.nordpoolgroup.com/api/marketdata/page/35?currency=EUR&endDate=$day-$month-$year"
fi