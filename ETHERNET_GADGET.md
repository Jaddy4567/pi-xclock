# Ethernet Gadget



## Pi

Configure the Pi device as per [https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget](https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget)

## Windows 11 RNDIS Driver Installation

When you plug your pi into Windows the Ethernet Gadget may install as a Com port but needs to be an Network Adaptor. change the driver of the comport to the mod-duo-rndis.zip driver below (Remember to scan on Virustotal before you install the driver)

[<img src="./README_ASSETS/Ethernet-Gadget-Windows Device Manager.png" width="400">](./README_ASSETS/Ethernet-Gadget-Windows%20Device%20Manager.png)

Download drivers for Windows 10/11 from https://modclouddownloadprod.blob.core.windows.net/shared/mod-duo-rndis.zip

More information on the Windows driver issues:

https://www.factoryforward.com/pi-zero-w-headless-setup-windows10-rndis-driver-issue-resolved/


## Find the Pi
You may have trouble finding the Pi because it self assigns an IP and that is on a /16 subnet (65536 hosts).

Use this `nmap` command on Mac to speed up finding it... 

**Note:** Make sure to set the `-e` paramater to the interface name of the  'RNDIS/Ethernet Gadget' in my case this was `en10`. (I tried nmap a couple of times without `-e en10` and it seemed to be sending traffic out the wrong interface (i.e. en0) and not finding the Pi)

```sh
sudo nmap -e en10 -sn -T5 --min-parallelism 200 169.254.0.0/16 -oG output.file.txt;
```



