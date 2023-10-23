#! /usr/bin/env nix-shell
#! nix-shell --pure -I channel:nixos-23.05-small -i dash -p nodejs dash
set -eu

echo '{}' > package.json
npm install --save-dev webpack webpack-cli typescript ts-loader http-server
npm install --save sql.js-httpvfs date-fns date-fns-tz
rm tsconfig.json
npx tsc --target es2020 --module es2020 --moduleResolution node --init