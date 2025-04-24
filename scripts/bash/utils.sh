#!/usr/bin/env bash

vercomp () {
    local a=${1%%.*} b=${2%%.*}
    [[ "10#${a:-0}" -gt "10#${b:-0}" ]] && return 1
    [[ "10#${a:-0}" -lt "10#${b:-0}" ]] && return 2
    a=${1:${#a} + 1} b=${2:${#b} + 1}
    [[ -z $a && -z $b ]] || vercomp "$a" "$b"
}