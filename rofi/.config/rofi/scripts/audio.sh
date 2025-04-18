#!/usr/bin/bash
# choose pulseaudio sink via rofi or dmenu
# changes default sink and moves all streams to that sink

sink=$(ponymix -t sink list |
    awk '/^sink/ {s=$1" "$2;getline;gsub(/^ +/,"",$0);print s" "$0}' |
    rofi -dmenu -p Audio Output -theme $HOME/.config/rofi/themes/material/audio.rasi |
    grep -Po '[0-9]+(?=:)') &&

ponymix set-default -d $sink &&
for input in $(ponymix list -t sink-input|grep -Po '[0-9]+(?=:)');do
	echo "$input -> $sink"
	ponymix -t sink-input -d $input move $sink
done
