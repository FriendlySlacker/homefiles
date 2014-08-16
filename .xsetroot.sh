#!/bin/bash

# Icon glyphs from font lemon
glyph_batt="⮏"
glyph_vol="⮟"
glyph_tim="⮖"
glyph_mus="⮕"


cpu(){
echo $(mpstat 2 1 | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ {printf"%d",100 - $field}')
}

net(){
  signal=`awk '/wlan0:/ {print $3}' /proc/net/wireless |sed -e 's/\.//g'`
  perc=`echo $[$signal *100 /70]`
  echo -e "$perc"
}


while true; do

DATETIME=`date`
UPTIME=`uptime | sed 's/.*up\s*//' | sed 's/,\s*[0-9]* user.*//' | sed 's/  / /g'`
VOLUME=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "Master Mute" } else { print "Master",$2"%" }}')
BATTERYSTATE=$( acpi -b | awk '{ split($5,a,":"); print substr($3,0,2), $4, "["a[1]":"a[2]"]" }' | tr -d ',' )
BATT=$( acpi | awk '{ print $4 }' | sed s/","//g )
TEXT=$(echo "`cat /proc/loadavg | cut -c 1-14` | `free -m | awk '$1 ~ /^-/ {print $3}'` MB |`date +%k:%M:%S`");
MPD=$(test -z "$(mpc current)" || mpc current)
RAM=$(free -m | awk '/-/ {print $3}')

xsetroot -name "${glyph_mus} Now Playing : ${MPD} | ${glyph_vol} ${VOLUME} | ${glyph_tim} ${DATETIME} | ${glyph_batt} ${BATT}"
         sleep 1;
done &
