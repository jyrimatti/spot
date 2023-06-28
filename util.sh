#!/bin/sh

urldecode() {
    local i="${*//+/ }"
    echo "${i//%/\\x}"
}

getParameters() {
    local q="$(urldecode $QUERY_STRING)"
    echo "--${q//&/ --}"
}
