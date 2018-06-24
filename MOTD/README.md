![alt text](https://github.com/Khord/pi_home_server/blob/master/MOTD/motd.png "MOTD Screenshot")

https://www.reddit.com/r/raspberry_pi/comments/5tqeb4/show_me_your_motd/

`service log2ram status | awk '/Active/ {print $2}'``df -h /var/log | awk '/log2ram/ {print " ("$3"/"$2")"}'`
