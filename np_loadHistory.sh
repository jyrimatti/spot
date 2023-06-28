#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-23.05-small -i bash -p curl nix
set -eu

for year in '2023' '2022' '2021';
do
  for month in '01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12';
  do
    for day in '01' '06' '11' '16' '21' '26';
    do
        echo "Loading $year-$month-$day..."
        ./np_load.sh "$year" "$month" "$day" | ./np_parse.sh | ./np_insert.sh
    done
  done
done