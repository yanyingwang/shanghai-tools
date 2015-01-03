#!/usr/bin/env bash
#The MIT License (MIT)

#Copyright (c) 2015 Yanying Wang

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.


INTERVAL=$1
SCREEN=$(xdpyinfo | grep -m1 dimensions | awk '{print $2}')
SCREENX=$(echo $SCREEN | awk -Fx '{print $1}')
SCREENY=$(echo $SCREEN | awk -Fx '{print $2}')


active_windows_size()
{
    echo $(xwininfo -id $(xdotool getactivewindow) -stats | \
            egrep '(Width|Height):' | \
            awk '{print $NF}') | \
        sed -e 's/ /x/'
}

fullscreen_app_info()
{
    xwininfo -id $(xdotool getactivewindow) -stats | \
        grep 'xwininfo:'
}

the_bund_light()
{
    sleep $(($INTERVAL * 60))
    if [[ $SCREEN == $(active_windows_size) ]]
    then
        #gnome-screensaver-command -d
        xdotool mousemove $(($SCREENX /2)) $(($SCREENY /2))
        echo "$(date): fullscreen app info: $(fullscreen_app_info)"
    else
        echo "$(date): fullscreen app none: sleep $INTERVAL minutes"
    fi
}


while :
do
    the_bund_light
done


