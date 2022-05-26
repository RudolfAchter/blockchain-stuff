# Icon for Chia App on Linux (Gnome)

The Chia GUI on Ubuntu / Debian is missing a nice Icon. To Fix this take this file:

- [chia-blockchain.svg](files/chia-blockchain.svg)

Copy it to your Linux Machine (or download it there). Then do this in a terminal:

```bash
#cd into pixmaps
cd /usr/share/pixmaps
#Rename old Icon
sudo mv chia-blockchain.png chia-blockchain.png.old
#Copy new Icon (its a scalable svg. Differend File Ending is no problem)
sudo cp /home/youruser/Downloads/chia-blockchain.svg /usr/share/pixmaps
```

Then you should see a nice Chia Icon on your applications screen

![](chia_icon_screenshot.png)