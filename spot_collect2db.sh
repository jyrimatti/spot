#! /bin/sh
set -eu

source ./spot_env.sh

./spot_load.sh | ./spot_parse.sh | ./spot_insert.sh