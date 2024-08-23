Describe 'current'
  Before "export DB=./test.db"
  Before "rm test.db"
  Before "sqlite3 test.db < spot_create.sql"
  Before "sqlite3 test.db < test.sql"

  Parameters
    sh
    json
    csv
  End

  sh() {
    ./current.sh $*
  }
  json() {
    ./current.json
  }
  csv() {
    ./current.csv | tail -n+4 | mlr --c2j cat | jq -c
  }

  instant() {
    [ "$(cat | grep -v '^Content' | grep -v '^Cache' | grep -v '^$' | mlr "--ijson" --ojson cat | jq -r '.[0].startTime')" = "$1" ]
  }

  price() {
    [ "$(cat | grep -v '^Content' | grep -v '^Cache' | grep -v '^$' | mlr "--ijson" --ojson cat | jq -r '.[0].centsPerKWh')" = "$1" ]
  }

  It "$1 without arguments, defaults to current tax"
    BeforeCall "export QUERY_STRING="
    When call $1
    The output should satisfy instant "$(date +'%Y-%m-%dT%H:00:00%z')"
    The output should satisfy price '7.000'
  End

  It "$1 with 0 tax, outputs current price"
    BeforeCall "export QUERY_STRING='tax=0'"
    When call $1 -x 0
    The output should satisfy instant "$(date +'%Y-%m-%dT%H:00:00%z')"
    The output should satisfy price '5.000'
  End

  It "$1 with delta, outputs price before current"
    BeforeCall "export QUERY_STRING='tax=0&delta=-1'"
    When call $1 -x 0 -d -1
    The output should satisfy instant "$(date +'%Y-%m-%dT%H:00:00%z' -d '-1 hour')"
    The output should satisfy price '4.000'
  End

  It "$1 with delta, outputs price after current"
    BeforeCall "export QUERY_STRING='tax=0&delta=1'"
    When call $1 -x 0 -d 1
    The output should satisfy instant "$(date +'%Y-%m-%dT%H:00:00%z' -d '+1 hour')"
    The output should satisfy price '6.000'
  End

  It "$1 with tax, outputs current price with tax"
    BeforeCall "export QUERY_STRING='tax=10'"
    When call $1 -x 10
    The output should satisfy instant "$(date +'%Y-%m-%dT%H:00:00%z')"
    The output should satisfy price '5.500'
  End

  It "$1 with timezone, outputs current time in zone"
    BeforeCall "export QUERY_STRING='tax=0&tz=UTC'"
    When call $1 -x 0 -t UTC
    The output should satisfy instant "$(date --utc +'%Y-%m-%dT%H:00:00Z')"
    The output should satisfy price '5.000'
  End
End