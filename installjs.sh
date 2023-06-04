#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-22.11-small -i bash -p nodejs
set -eu

echo '{}' > package.json
npm install --save-dev webpack webpack-cli typescript ts-loader http-server
npm install --save sql.js-httpvfs date-fns date-fns-tz
npx tsc --init