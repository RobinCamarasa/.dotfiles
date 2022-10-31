
start_dwm (){
    feh --bg-fill "${HOME}/documents/wallpapers/background.png"
    sc -a
    ${HOME}/.myscripts/bar &
    nm-applet &
    workrave &
    blueman-applet &
    setxkbmap -layout us -variant intl
    dunst &
    redshift &
    xset r off
    exec dwm
}

start_dwm
