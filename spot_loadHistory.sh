#! /usr/bin/env nix-shell
#! nix-shell --pure --keep ENTSOE_TOKEN -I channel:nixos-23.11-small -i dash -p curl nix
set -eu

cat DAY_AHEAD_PRICES_201501010000-201601010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_201601010000-201701010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_201701010000-201801010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_201801010000-201901010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_201901010000-202001010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_202001010000-202101010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_202101010000-202201010000.xml | ./spot_parse.sh | ./spot_insert.sh
cat DAY_AHEAD_PRICES_202201010000-202301010000.xml | ./spot_parse.sh | ./spot_insert.sh

for year in '2023'
do
  for month in '01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12';
  do
    echo "Loading $year-$month..."
    ./spot_load.sh "$year" "$month" | ./spot_parse.sh | ./spot_insert.sh
  done
done