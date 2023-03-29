# bbb-video-download-manual-init
This is bash script to manually or scheduled run of <a href=https://github.com/tilmanmoser/bbb-video-download>tilmanmoser's dockerized bbb-video-download script</a> for non-rendered presentations.

Script checks published presentations folder of BBB for the rendered video.mp4 file (file name is configurable) and runs previously installed rendering tilmanmoser's bbb-video-download script for all found non-rendered published presentations. If there is no non-rendered published presentations then script exit.

It can be used with installed or <a href=https://github.com/bigbluebutton/docker>dockerized</a> BigBlueButton instance. Just make sure to set configurable variables in the corresponding section of this script.

**VARIABLES**:

***bbb_video_download_path*** - the path to gitcloned and configured bbb-video-download script. Default is /opt/bbb-video-download

***published_path*** - the path to the published bbb presentations. Default for the installed BBB is /var/bigbluebutton/published and for the dockerized BBB is 
/var/lib/docker/volumes/bbb-docker_bigbluebutton/_data/published

***file_name*** - output mp4 file name. Default is video.mp4

***log_file*** - full file path for this script logging output

# !!!IMPORTANT!!!
In order to proper run of this script there must be bigbluebutton user and group with UID and GID 998 created with **dockerized BBB instance**.
If you use **installed BBB instance** then above requirement is unnecessary.

Tested on the installed BBB 2.4 and dockerized BBB 2.5 versions.
# !!!KNOWN issues!!!
Current bbb-video-download has an issue with memory leak when use alpine newer then 3.11. To build normal functioning bbb-video-download edit it's Dockerfile as the following:
```
--- a/src/Dockerfile
+++ b/src/Dockerfile
@@ -1,8 +1,8 @@
-FROM node:12-alpine
+FROM node:12-alpine3.11 
```
