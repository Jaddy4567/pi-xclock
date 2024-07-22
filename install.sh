#!/bin/sh

dpkg -l x11-apps

if [ "$?" -ne "0" ];
then
    sudo apt update && sudo apt install xorg xserver-xorg xinit x11-apps unclutter -y
fi

sudo usermod -a -G tty pi

( 
cat << 'XSERVERRC'
#!/bin/sh
# Start an X server with power management disabled so that the screen never goes blank.
exec /usr/bin/X -s 0 -dpms -nolisten tcp "$@"
XSERVERRC
) > ~/.xserverrc

(
cat << 'XSESSION' 
#!/bin/sh
# This tells X server to start XClock at startup
xclock -digital
XSESSION
) > ~/.xsession

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

if [ ! -d ~/.fonts ];
then
    mkdir ~/.fonts
    cp ubuntu.ttf ~/.fonts/
fi
# fc-cache -f
# fc-list | grep -i ubuntu


sudo sed -ibak -e 's/allowed_users=console/allowed_users=anybody\nneeds_root_rights=yes/g' /etc/X11/Xwrapper.config


# clock service

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
) | sudo  tee /etc/systemd/system/clock.service

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
