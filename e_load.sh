#! /usr/bin/env nix-shell
#! nix-shell --pure --keep SECURITY_TOKEN -I channel:nixos-22.11-small -i bash -p curl cacert yq

if [ $# -eq 0 ];
then 
  curl "https://web-api.tp.entsoe.eu/api?documentType=A44&in_Domain=10YFI-1--------U&out_Domain=10YFI-1--------U&TimeInterval=$(date -u +'%Y-%m-%dT%H:00Z')/$(date -u +'%Y-%m-%dT%H:00Z' -d '+2 days')&securityToken=$SECURITY_TOKEN"
else
  year=$1
  month=$2
  curl "https://web-api.tp.entsoe.eu/api?documentType=A44&in_Domain=10YFI-1--------U&out_Domain=10YFI-1--------U&TimeInterval=$year-$month-01T00:00Z/$(date +'%Y-%m-%dT%H:00Z' -d '$year-$month-01' -d '+1 month')&securityToken=$SECURITY_TOKEN"
fi
