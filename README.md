# TingScript
Bash script for filling the TING pen with audio books under Linux, which have to be downloaded

## Requirements ##
- TING pen with USB cable
- bash as shell (maybe other can run well, but can't be guaranteed)

## Before using the script
- put in the USB cable into the TING pen

## Usage of the script
```bash
./linux.sh
```
For auto detection of Ting folder over mount point and TBD.TXT/tbd.txt filename.

## Usage if auto detection fails
Check in which folder the $ting folder shows up, where the TBD.TXT file is
```shell
./linux.sh <pathOfFolderWhere$tingIs>
```
For example ./linux.sh /media/Ting if the /media/Ting includes the folder $ting in which the TBD.TXT file is

## Contributors
- Ralf Meyer https://github.com/ralfdonald
- Bernd Wurst https://github.com/bwurst
- Stefan Dangl https://github.com/stangls
- frog23 https://github.com/frog23