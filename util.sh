#!/bin/sh

urldecode() { local i="${*//+/ }"; echo "${i//%/\\x}"; }

getQuery() {
    saveIFS=$IFS
    IFS='=&'
    query_params=($(urldecode $QUERY_STRING))
    IFS=$saveIFS

    for ((i=0; i<${#query_params[@]}; i+=2))
    do
        export "var_${query_params[i]}=${query_params[i+1]}"
    done
}

err() {
    if [ "$REQUEST_METHOD" != "" ];
    then
        echo 'Status: 400 Bad Request'
        echo 'Content-Type: text/plain'
        echo ''
    fi
    echo "$1"
}