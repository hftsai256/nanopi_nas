#!/bin/bash

# OpenSCAD batch rendering script by RedWagon on Thingiverse
# https://www.thingiverse.com/thing:2985920
# 
# Modified by Halley Tsai for MacOS
# requires GNU grep which can be installed by homebrew (brew install grep)
# usage: render_scad.sh $input_scad_file

CRE="$(echo -e '\r\033[K')"
RED="$(echo -e '\033[1;31m')"
GREEN="$(echo -e '\033[1;32m')"
YELLOW="$(echo -e '\033[1;33m')"
BLUE="$(echo -e '\033[1;34m')"
MAGENTA="$(echo -e '\033[1;35m')"
CYAN="$(echo -e '\033[1;36m')"
WHITE="$(echo -e '\033[1;37m')"
NORMAL="$(echo -e '\033[0;39m')"
INFO=$NORMAL

print_load() {
    echo -n "Load average: "
    sysctl -n vm.loadavg
}

fail() {
    echo "$RED$@$NORMAL"
    exit 1
}

get_variable() {
    variable=$( cat $file | egrep '( |^)if' | egrep '(.stl|.dxf)' | ggrep -Po '[^\s^(]*(?=\s*==)' | uniq )
    [ "$variable" ] || return 1
    echo "${INFO}Found variable \"$variable\" for defining multiple outputs."
}

process_all() {
    for output in $( cat $file | egrep '( |^)if' | egrep -o '[^"^ ^'\'']*(.stl|.dxf)' ); do
        echo "${INFO}Starting $output...$NORMAL"
        time $openscad -o "$dir/$output" -D $variable'="'$output'"' $file && echo "$output ${GREEN}OK$NORMAL" || echo "$output ${RED}failed$NORMAL" &
    done
}

process_one() {
    output=$( echo $file | sed 's/\.scad$/.stl/' )
    echo "${INFO}Starting $output...$NORMAL "
    time $openscad -o "$dir/$output" $file && echo "$output ${GREEN}OK$NORMAL" || echo "$output ${RED}failed$NORMAL"
}

openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
which $openscad &> /dev/null || openscad="openscad-nightly"
which $openscad &> /dev/null || fail "Cound not find openscad"
file=$1
[ "$file" ] || fail "File not specified"
[ "$2" ] && fail "Too many options"
[ -f "$file" ] || fail "File does not exist"
echo $file | ggrep -q '\.scad$' || fail "Not an scad file"
dir=$( dirname $file )

print_load
get_variable && process_all || process_one
wait
echo ""
print_load
