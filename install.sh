#!/bin/bash

# from home
cd ~

PI_NAME="${1:-mah-clock1}"

echo "Installing pi-xclock with hostname $PI_NAME"
echo -n "Enter y or Y to Continue. Anything else to quit: "
read s

case $s in
Y | y)
    echo Installing..
    ;;
*)
    echo quitting
    exit 0
    ;;
esac

NOW=$(date +'%Y-%m-%dT%H_%M_%S')

echo Setting hostname to $PI_NAME

sudo sed -i.bak-$NOW "s/127\.0\.1\.1.*/127.0.1.1\t$PI_NAME/" /etc/hosts

sudo cp /etc/hostname /etc/hostname.bak-$NOW

sudo hostnamectl set-hostname $PI_NAME

# echo $PI_NAME | sudo dd of=/etc/hostname

dpkg -l x11-apps 2>&1 >/dev/null

if [ "$?" -ne "0" ]; then
    echo Installing dependencies
    sudo apt update && sudo apt install xorg \
        xserver-xorg xinit x11-apps unclutter \
        fontconfig -y
fi

dpkg -l fonts-urw-base35 2>&1 >/dev/null

if [ "$?" -ne "0" ]; then
    echo Installing Nimbus Sans Font
    sudo apt install fonts-urw-base35 -y
fi

if [ "$?" -ne "0" ]; then
    echo Installing dependencies
    sudo apt update && sudo apt install xorg xserver-xorg xinit x11-apps unclutter -y
fi

echo Adding $USER to tty group
sudo usermod -a -G tty pi

echo Creating .xserverrc
(
    cat <<'XSERVERRC'
#!/bin/sh
# Start an X server with power management disabled so that the screen never goes blank.
exec /usr/bin/X -s 0 -dpms -nolisten tcp "$@"
XSERVERRC
) >~/.xserverrc

echo Creating .xsession
(
    cat <<'XSESSION'
#!/bin/sh
# to change background colour uncomment and edit the #RGB
# xsetroot -solid '#363F59'
# This tells X server to start XClock at startup
xclock -digital -bw 0
XSESSION
) >~/.xsession

echo Creating .Xresources
(
    cat <<'XRESOURCES'
! default white #FFF
XClock*foreground: #FFFFFF
! default black #000
XClock*background: #000000
! 12 hour time 01-12 = %I
! Use man strftime for format strings
XClock*strftime: %I:%M:%S
XClock*update: 1
XClock*geometry: 1800x900+70+280
XClock*padding: 0
! XClock*face: Ubuntu Sans Mono :pixelsize=380 :weight=medium
! XClock*face: Aurulent Sans Mono :style=Regular :pixelsize=360
XClock*face: Nimbus Sans Narrow:style=Regular:size=300
XClock*analog: false
XRESOURCES
) >~/.Xresources

USER_FONTS_DIR=~/.fonts

[ -d $USER_FONTS_DIR ] || mkdir $USER_FONTS_DIR

if [ ! -f $USER_FONTS_DIR/AurulentSansMono-Regular.otf ]; then
    echo Installing AurulentSansMono font
    wget -O $USER_FONTS_DIR/AurulentSansMono-Regular.otf \
        https://github.com/Jaddy4567/pi-xclock/raw/main/fonts/AurulentSansMono/AurulentSansMono-Regular.otf
fi

if [ ! -f $USER_FONTS_DIR/ubuntu.ttf ]; then
    echo Installing Ubuntu Sans Mono font
    wget -O $USER_FONTS_DIR/ubuntu.ttf \
        https://github.com/google/fonts/raw/main/ufl/ubuntusansmono/UbuntuSansMono%5Bwght%5D.ttf
fi

sudo sed -i.bak-$NOW -e 's/allowed_users=console/allowed_users=anybody\nneeds_root_rights=yes/g' /etc/X11/Xwrapper.config

# clock service

echo Creating clock.service

(
    cat <<'CLOCK_SERVICE'
[Unit]
Description=Clock
After=network-online.target
DefaultDependencies=no

[Service]
User=pi
ExecStart=/usr/bin/startx
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
CLOCK_SERVICE
) | sudo dd of=/etc/systemd/system/clock.service

sudo systemctl daemon-reload

sudo systemctl enable clock

grep -q 'disable_splash' /boot/config.txt

if [ "$?" -eq 1 ]; then
    echo Inserting disable_splash into /boot/config.txt
    # removes multi-colour screen on boot
    sudo sed -i.bak-$NOW '/Some settings may/a \
disable_splash=1' /boot/config.txt
fi

# if you want to remove the boot text add queit
# grep -q 'quiet' /boot/cmdline.txt

# if [ "$?" -eq 1 ];
# then
# remove scrolling boot text and raspberry logos
# echo inserting quiet into /boot/cmdline.txt
# sudo sed -i.bak-$NOW 's/$/ quiet/' /boot/cmdline.txt
# fi

echo Reboot to complete the install
