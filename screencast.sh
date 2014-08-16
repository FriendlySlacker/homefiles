#!/bin/bash
#
# Author:       Twily           2014
# Description:  Records a window or the desktop and converts the video to webm format.
# Requires:     ffmpeg, xwininfo
# Useage:       sh screencast -h|--help

MODE="desktop"                  # Default "desktop" ["window" || "desktop"]
MARGIN=10                       # Margin in window mode [0-20]
FPS=30                          # Frames Per Second [12-60]
PRESET="ultrafast"              # Default "ultrafast" (x264 --help for preset list)
CRF=0                           # Constant Rate Factor [0-51] (Lower is better quality)
QMAX=5                          # Lowering quantization increases bitrate/quality [1-31]
FULLSCREEN="1366x768"          # Set your desktop resolution

OUTPUT="/home/waldo/out.webm"
TMP="/home/waldo/out.mkv"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo -e "Useage: screencast [OPTIONS]\n"
    echo "  -h|--help           Display help"
    echo "  -m|--mode mode      Set mode (\"desktop\" or \"window\")"
    echo "  -s|--space number   Set margin in window mode [0-20]"
    echo "  -f|--fps number     Set Frames Per Second [12-60]"
    echo "  -c|--crf number     Set Constant Rate Factor [0-51] (Lower is better quality)"
    echo "  -q|--qmax number    Set maximum quantization (Lower is better quality) [1-31]"
    echo "  -p|--preset preset  Set preset (x264 --help for preset list)"
    echo "  -o|--output file    Output webm file"
    echo -e "\n"; exit 0
fi

OPTS=`getopt -o m:s:o:f:c:p:q: --long mode:,space:,output:,fps:,crf:,preset:,qmax: -- "$@"`
eval set -- "$OPTS"

ERROR=0

while true; do
    case "$1" in
        -m|--mode)   MODE="$2";   shift 2;;  -s|--space)  MARGIN="$2"; shift 2;;
        -o|--output) OUTPUT="$2"; shift 2;;  -p|--preset) PRESET="$2"; shift 2;;
        -f|--fps)    FPS="$2";    shift 2;;  -c|--crf)    CRF="$2";    shift 2;;
        -q|--qmax)   QMAX="$2";   shift 2;;
        --)          shift; break;;          *) echo "Internal error!"; exit 1
    esac
done

if [ "$MODE" = "window" ]; then
    WINFO=$(xwininfo)
    
    WINX=$(($(echo $WINFO|grep -Po 'Absolute upper-left X: \K[^ ]*')-$MARGIN))
    WINY=$(($(echo $WINFO|grep -Po 'Absolute upper-left Y: \K[^ ]*')-$MARGIN))
    WINW=$(($(echo $WINFO|grep -Po 'Width: \K[^ ]*')+($MARGIN*2)))
    WINH=$(($(echo $WINFO|grep -Po 'Height: \K[^ ]*')+($MARGIN*2)))

    ffmpeg -f x11grab -s "$WINW"x"$WINH" -r $FPS -i $DISPLAY"+$WINX,$WINY" -c:v libx264 -preset $PRESET -crf $CRF "$TMP" || ERROR=1
else
    ffmpeg -f x11grab -s $FULLSCREEN -r $FPS -i $DISPLAY -c:v libx264 -preset $PRESET -crf $CRF "$TMP" || ERROR=1
fi

ffmpeg -i "$TMP" -c:v libvpx -qmin 1 -qmax $QMAX -preset $PRESET -crf $CRF -c:a libvorbis "$OUTPUT" || ERROR=1
if [ -f "$TMP" ]; then rm -f "$TMP"; fi

if [ "$ERROR" -eq 0 ]; then
    echo -e "\n\n\033[0;32mRecording and Converting has finished and \"\033[0;34m$OUTPUT\033[0;32m\" has been \033[1;32mSuccessfully created\033[0;32m.\033[0m\n\n";
else
    echo -e "\n\n\033[0;31mAn unexpected Error prevented the screen recorder to complete, screencast was \033[1;31mNot created\033[0;31m.\033[0m\n\n";
fi

