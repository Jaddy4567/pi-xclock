## Changing Text & Background Colours

To change the background colour also requires changing the colour of the root window and turning off the Xclock app border.

To do this edit `~/.xsession` to add a call to `xsetroot` to set the X root window colour and set xclock's `-bw` (border width) parameter to zero

Adjust foreground/background colour and geometry in `~/.Xresources`

```sh
#!/bin/sh
# change root window
xsetroot -solid '#434343'
# This tells X server to start XClock at startup
xclock -digital -bw 0
```
Change `~/.Xresources` colours

```sh
! white text #FFFFFF
XClock*foreground: yellow

! custom background
XClock*background: #434343
```

