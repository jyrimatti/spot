#! /usr/bin/env nix-shell
#! nix-shell -I channel:nixos-22.11-small -i bash -p jq
set -eu

jq -r '.data.Rows[] | select(.IsExtraRow == false) | (.StartTime | sub("[^T]*T";"")) as $ST | (.EndTime | sub("[^T]*T";"")) as $ET | (.Columns | map((.Name | strptime("%d-%m-%Y") | strftime("%Y-%m-%d")) as $DATE | {date:$DATE, startTime:$ST, endTime:$ET, instant: ($DATE+" "+$ST), centsPerKWh:(.Value | sub("[,]";".") | tonumber | .*100/1000)}))' | jq -s add
