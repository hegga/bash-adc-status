#!/bin/bash

URL="https://developer.apple.com/support/system-status/"
CURL=`which curl`
SED=`which sed`
GREP=`which grep`

print_online () {
    printf "\r\033[2K  [ \033[00;32mONLINE\033[0m ] $1\n"
}

print_offline () {
    printf "\r\033[2K  [\033[0;31mOFFLINE\033[0m] $1\n"
}

IFS=$'\n' 

# TODO:
# Nicer, but needs some tweaking, have to go buy beer before it closes
#DEP=`echo $line | $SED -e 's/<[^>]*>//g;s/^[ \t]//g'`
# TODO:
# Fix &amp; substitution

for line in `$CURL -s $URL | $GREP -Evi "<span>O(n|ff)line</span>"`; do
    if echo "$line" | $GREP -q '<div class="offline-icon"></div>'; then
        DEP=`echo $line | $GREP -oEe "<span>.*</span>" | $SED -e 's/<[^>]*>//g' -e 's/&amp;/&/g'`
        print_offline $DEP
    elif echo "$line" | $GREP -q '<div class="online-icon"></div>'; then
        DEP=`echo $line | $GREP -oEe "<span>.*</span>" | $SED -e 's/<[^>]*>//g' -e 's/\&amp\;/&/g'`
        print_online $DEP
    fi
done
