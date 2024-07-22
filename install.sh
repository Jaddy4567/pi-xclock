#!/bin/sh

dpkg -l x11-apps 2>&1 > /dev/null

if [ "$?" -ne "0" ];
then
    echo Installing dependencies
    sudo apt update && sudo apt install xorg xserver-xorg xinit x11-apps unclutter -y
fi

echo Adding $USER to tty group
sudo usermod -a -G tty pi

echo Creating .xserverrc
( 
cat << 'XSERVERRC'
#!/bin/sh
# Start an X server with power management disabled so that the screen never goes blank.
exec /usr/bin/X -s 0 -dpms -nolisten tcp "$@"
XSERVERRC
) > ~/.xserverrc

echo Creating .xsession
(
cat << 'XSESSION' 
#!/bin/sh
# This tells X server to start XClock at startup
xclock -digital
XSESSION
) > ~/.xsession

echo Creating .Xresources
(
cat << 'XRESOURCES'
XClock*foreground: #FFFFFF
XClock*background: #000000
XClock*strftime: %T
XClock*update: 1
XClock*geometry: 1800x900+100+300
XClock*padding: 0
XClock*face: Ubuntu Sans Mono :pixelsize=380 :weight=medium
XClock*analog: false
XRESOURCES
) > ~/.Xresources

if [ ! -f ~/.fonts/ubuntu.ttf ];
then
    echo Installing font
    mkdir ~/.fonts
    cp ubuntu.ttf ~/.fonts/
fi

sudo sed -ibak -e 's/allowed_users=console/allowed_users=anybody\nneeds_root_rights=yes/g' /etc/X11/Xwrapper.config

# clock service

echo Creating clock.service

(
cat << 'CLOCK_SERVICE'
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

if [ "$?" -eq 1 ];
then
echo inserting disable_splash
sudo sed -ibak '/Some settings may/a \
disable_splash=1' /boot/config.txt
fi

grep -q 'quiet' /boot/cmdline.txt

if [ "$?" -eq 1 ];
then
echo inserting quiet
sudo sed -ibak 's/$/ quiet/' /boot/cmdline.txt
fi
