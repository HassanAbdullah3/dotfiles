#!/bin/bash

interval=0

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf " cpu: "
  printf "$cpu_val "
}

pkg_updates() {
  # updates=$(doas xbps-install -un | wc -l) # void
  updates=$(checkupdates | wc -l)   # arch , needs pacman contrib
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ -z "$updates" ]; then
    printf " Fully Updated"
  else
    printf "  $updates"" updates"
  fi
}

brightness() {
  printf " "
  printf "$(cat /sys/class/backlight/*/brightness)"
}

mem() {
  printf " "
  printf "$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf " 󰤨  " ;;
	down) printf " 󰤭  " ;;
	esac
}

clock() {
	printf "󱑆 "
	printf "$(date '+%I:%M' )"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done
