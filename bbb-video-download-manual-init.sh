#!/bin/bash

# this script checks published catalogue for video.mp4 file and if there is no such file it runs bbb-video-download container from its directory, see config variables below
# there must be bigbluebutton user and group in system with UID and GID of 998
# ### CONFIGURATION VARIABLES ###
bbb_video_download_path="/opt/bbb-video-download"
published_path="/var/bigbluebutton/published"
file_name=video.mp4
log_file="/var/log/bbb-video-download.log"
# ### CONFIGRATION VARIABLES END ###

no_video_path=`find $published_path -mindepth 2 -maxdepth 2 -type d '!' -exec test -e "{}/$file_name" ';' -print`

while IFS= read -r line
do
     #echo "A line of input: $line"
    if [ -z "$line" ]
    then
        echo "There is no convert waiting presentations!"
    else
        echo `date --rfc-3339=seconds`" There was not found rendered video file in the folder $line. Rendering started!" >> $log_file
        BBB_UID="$(cat /etc/passwd | grep bigbluebutton | cut -d: -f3)"
        BBB_GID="$(cat /etc/passwd | grep bigbluebutton | cut -d: -f4)"
        echo "PLACEHOLDER FOR VIDEO RENDER! THIS FILE WILL BE REPLACED WITH RENDERED ONE AFTER RENDERING COMPLETION!" >> $line/$file_name
        cd $bbb_video_download_path
        sudo -u bigbluebutton docker-compose run --rm --user $BBB_UID:$BBB_GID app node index.js -i $line -o $line/$file_name>>$log_file && echo `date --rfc-3339=seconds`" $line/$file_name was successfully created!" >> $log_file&
    fi
done < <(printf '%s\n' "$no_video_path")
