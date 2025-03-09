#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash coreutils curl cacert jq

baseurl="https://dashboard.elering.ee/api/nps/price?"

curl --no-progress-meter "${baseurl}start=$(date -u +'%Y-%m-%dT%H:00:00Z')&end=$(date -u +'%Y-%m-%dT%H:00:00Z' -d '+2 days')" \
  | jq '.data.fi'
