#! /usr/bin/env nix-shell
#! nix-shell --pure
#! nix-shell -I channel:nixos-24.05-small -i dash -p dash jq sqlite gnused
set -eu

# The data is always in UTC
export TZ=UTC

# Entsoe started to produce missing values, which (I guess) have the same price as the previous hour.
# So let's fill in missing values for the previous days or so.

echo "INSERT INTO spot(instant,centsPerKWh)
      SELECT missing, (SELECT centsPerKWh FROM spot WHERE instant = prev)
      FROM (SELECT unixepoch(datetime(instant, 'unixepoch', '-1 hour')) missing,
                   LAG(instant) OVER (ORDER BY instant) prev,
                   instant - LAG(instant) OVER (ORDER BY instant) diff
            FROM spot WHERE instant > unixepoch('now', '-7 days'))
      WHERE diff > 3600" |
sqlite3 spot.db