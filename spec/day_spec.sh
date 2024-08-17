Describe 'day'
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
    ./day.sh $*
  }
  json() {
    ./day.json
  }
  csv() {
    ./day.csv | tail -n+4 | mlr --c2j cat | jq -c
  }

  It "$1 without arguments, prints usage"
    BeforeRun "export QUERY_STRING="
    When run ./day.$1
    The status should equal 1
    The output should include "Usage:"
    The output should include "Options:"
  End

  It "$1 with 0 tax, outputs given day"
    BeforeCall "export QUERY_STRING='tax=0&day=2000-01-02'"
    When call $1 -x 0 -d 2000-01-02
    The output should end with '[{"startTime":"2000-01-02T00:00:00+0200","centsPerKWh":2.000},{"startTime":"2000-01-02T01:00:00+0200","centsPerKWh":3.000}]'
  End

  It "$1 with tax, outputs given day with tax"
    BeforeCall "export QUERY_STRING='tax=10&day=2000-01-02'"
    When call $1 -x 10 -d 2000-01-02
    The output should end with '[{"startTime":"2000-01-02T00:00:00+0200","centsPerKWh":2.200},{"startTime":"2000-01-02T01:00:00+0200","centsPerKWh":3.300}]'
  End

  It "$1 defaults to tax of the corresponding day 1"
    BeforeCall "export QUERY_STRING='day=2000-01-01'"
    When call $1 -d 2000-01-01
    The output should end with '[{"startTime":"2000-01-01T23:00:00+0200","centsPerKWh":1.100}]'
  End

  It "$1 defaults to tax of the corresponding day 2"
    BeforeCall "export QUERY_STRING='day=2000-01-02'"
    When call $1 -d 2000-01-02
    The output should end with '[{"startTime":"2000-01-02T00:00:00+0200","centsPerKWh":2.400},{"startTime":"2000-01-02T01:00:00+0200","centsPerKWh":3.600}]'
  End

  It "$1 with timezone, outputs given day in zone"
    BeforeCall "export QUERY_STRING='tax=0&tz=UTC&day=2000-01-01'"
    When call $1 -x 0 -t UTC -d 2000-01-01
    The output should end with '[{"startTime":"2000-01-01T21:00:00+0000","centsPerKWh":1.000},{"startTime":"2000-01-01T22:00:00+0000","centsPerKWh":2.000},{"startTime":"2000-01-01T23:00:00+0000","centsPerKWh":3.000}]'
  End
End