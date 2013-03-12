#! /bin/bash
CAPS=`xset q | grep 'Caps Lock: \+on' | wc -l`
NUM=`xset q | grep 'Num Lock: \+on' | wc -l`

if [ $CAPS == '1' ]; then
    CAPS='<span background="#4e8dba" color="black"> C </span>'
elif [ $CAPS == '0' ]; then
    CAPS='<span  color="white"> C </span>'
fi

if [ $NUM == '1' ]; then
    NUM='<span background="#4e8dba" color="black"> N </span>'
elif [ $NUM == '0' ]; then
    NUM='<span  color="white"> N </span>'
fi

echo "$CAPS | $NUM"
