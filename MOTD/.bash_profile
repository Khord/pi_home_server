function extend (){
  local str="$1"
  let spaces=60-${#1}
  while [ $spaces -gt 0 ]; do
    str="$str "
    let spaces=spaces-1
  done
  echo "$str"
}

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "$(tput setaf 4)"\
"  _  ___                ____  _
 | |/ / |__   ___  _ __|  _ \(_)   OpenVPN........: `service openvpn status | awk '/Active/ {print $2}'`
 | ' /| '_ \ / _ \| '__| |_) | |   PiHole.........: `pihole status | awk '/DNS/ {print $5}'`
 | . \| | | | (_) | |  |  __/| |   NoIP DUC.......: `service noip2 status | awk '/Active/ {print $2}'`
 |_|\_\_| |_|\___/|_|  |_|   |_|   HomeAssistant..: `service home-assistant@homeassistant status | awk '/Active/ {print $2}'`"

echo "$(tput setaf 2)
   .~~.   .~~.    `date +"%A, %e %B %Y, %r"`
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.    Uptime.............: ${UPTIME}
  : .~.'~'.~. :   Disk Space.........: "$(extend "$(df -h / | awk 'NR==2 { printf "Used: %sB, Free: %sB",$3,$4; }')")"
 ~ (   ) (   ) ~  Memory.............: "$(extend "$(free -m | awk 'NR==2 { printf "Used: %sMB, Free: %sMB",$3,$4; }')")"
( : '~'.~.'~' : ) CPU Temp/Load......: `/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9"`°C | ${one} | ${five} | ${fifteen}
 ~ .~ (   ) ~. ~  Running Processes..: `ps ax | wc -l | tr -d " "` | `ps U $(whoami) h | wc -l` belong to user: `whoami`
  (  : '~' :  )   IP Addresses.......: `hostname -I | awk '{print $1}'` | `dig +short myip.opendns.com @resolver1.opendns.com`
   '~ .~~~. ~'    SSH Connections....: `w -s | grep pts | wc -l` users currently logged in
       '~'        Package Upgrades...: `apt-get -s dist-upgrade | awk '/^Inst/ {print $2}' | wc -l` upgrades are pending
$(tput sgr0)"
