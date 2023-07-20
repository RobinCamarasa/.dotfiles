
start_dwm (){
    feh --bg-fill "${HOME}/documents/wallpapers/background.png"
    sc -a

    while true; do
        TIME=$(date +"%Y-%m-%d %H:%M:%S")
        NET=$(nmcli c show | grep wlan0 | sed -e 's/^\(\S*\)\s.*$/\1/g')
        CPU=$(mpstat | tail -n1 | sed -e 's/^\S*\s*\S*\s*\S*\s*\(\S*\)\s*\S*\s*\(\S*\).*$/CPU: (usr) \1% | (sys) \2%/g')
        RAM=$(free -m | grep Mem | sed -e 's/^.*:\s*\([0-9]*\)\s*\([0-9]*\).*/(100\*\2)\/\1/g' | bc -i | tail -n1)
        RAM=$(echo "RAM : ${RAM}%")
        ROOT=$(df /dev/sda3 | tail -n1 | sed -e 's/^.* \([0-9]\+\)%.*$/root: \1%/g')
        HOME=$(df /dev/sda4 | tail -n1 | sed -e 's/^.* \([0-9]\+\)%.*$/home: \1%/g')
        BATTERY=$(acpi -b | tail -n1 | sed 's/^.* \(.*\),.*$/Battery: \1/g')
        IP_VPN=$(ip a | grep "inet.*tun0" | sed -e 's/^.* \(.*\)\/.*$/VPN: \1/g')
        IP=$(ip a | grep "inet.*wlan0" | sed -e 's/^.* \(.*\)\/.*$/\1/g')
        xsetroot -name "${CPU} | ${RAM} | ${ROOT} | ${HOME} | ${BATTERY} | ${IP_VPN} | ${IP} | ${NET} | ${TIME} "
        sleep 1
    done &

    nm-applet &
    blueman-applet &
    dunst &
    redshift-gtk &
    setxkbmap -layout us -variant intl
    exec dwm
}

start_dwm
