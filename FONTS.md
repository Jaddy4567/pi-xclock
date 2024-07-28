## Fonts

## Variable Width
Tall narrow fonts fill the screen better

```sh
// Nimbus is equivalent to Helvetica
sudo apt-get install fonts-urw-base35
```

```txt
! .Xresources
XClock*padding: Nimbus Sans Narrow:style=Bold:size=400
```

## Mono-spaced

Check various programming \`mono' fonts at [https://www.programmingfonts.org/](https://www.programmingfonts.org/)

To avoid having a dot or slash in the zero select a font such as 

- Chivo Mono
- Arulent Sans Mono
- Sax Mono
- APL385
- Average Mono

### Install fonts

```sh
# Download and unpack them and then copy them into `~/.fonts
cp NameOfFont.ttf ~/.fonts
```

### View installed fonts

```sh
# make sure fontconfig is installed so you have fc-list
sudo apt-get install fontconfig

fc-list | grep -i FontName

# e.g
fc-list | grep -i average

#output
/home/pi/.fonts/AverageMonoItalic.ttf: AverageMono:style=Italic
/home/pi/.fonts/AverageMono.ttf: AverageMono:style=Regular
/home/pi/.fonts/AverageMonoBoldItalic.ttf: AverageMono:style=Bold Italic
/home/pi/.fonts/AverageMono.otf: AverageMono:style=Regular
/home/pi/.fonts/AverageMonoBold.ttf: AverageMono:style=Bold
/home/pi/.fonts/AverageMonoBoldItalic.otf: AverageMono:style=Bold Italic
/home/pi/.fonts/AverageMonoItalic.otf: AverageMono:style=Italic
/home/pi/.fonts/AverageMonoBold.otf: AverageMono:style=Bold
```

You will need to edit `~/.Xresources`

```text
XClock*foreground: #FFFFFF
XClock*background: #000000
! 12 hour time 01-12
XClock*strftime: %I:%M:%S
XClock*update: 1
XClock*geometry: 1800x1080+90+300
! XClock*geometry: 1800x900+100+300
! XClock*geometry: 1800x1080+40+300
XClock*padding: 0
! XClock*face: Ubuntu Sans Mono :pixelsize=380 :weight=medium
XClock*face: Aurulent Sans Mono :style=Regular :pixelsize=360
! XClock*face: APL385 Unicode :style=Regular :size=300
! XClock*face: AverageMono:style=Bold:size=280
XClock*analog: false
```
