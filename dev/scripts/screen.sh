#!/usr/bin/bash

dir="$HOME/stuff/screenshots"
tmpfile="maim_screenshot.png"

maim $@ $tmpfile

[[ -e "$tmpfile" ]] || exit;

filename="$(date +'%Y-%m-%d_%Hh%Mm%Ss')_$(file $tmpfile | sed 's/.*, \([0-9]*\) x \([0-9]*\), .*/\1x\2/').png"

mv $tmpfile "$dir/$filename"
chromium "http://www.narthorn.com/stuff/screenshots/$filename"

