# TingScript

Bash script for filling the TING pen with audio books under Linux, which have to be downloaded

## Requirements

- TING pen with USB cable
- bash as shell (maybe other can run well, but can't be guaranteed)

## Installation

1. Open a terminal

2. Go to the directory where you want to install the script

3. Clone the repository:

   ```bash
   git clone https://github.com/ralfdonald/TingScript.git
   ```

## Usage

1. The script downloads "missing" books, i.e. books that the TING pen has "seen" but which are currently not stored on the pen. Therefore, turn on the pen and
use it to touch the activation icons of all the books that you want to download.

2. Connect the TING pen to your computer using the USB cable

3. Execute the script:

   ```bash
   ./linux.sh
   ```

   The script will try to auto-detect the location of the TING pen's mount
   point. If that fails you can pass the mount point to the script as a
   parameter:

   ```bash
   ./linux.sh path/to/the/mount/point
   ```

   The path that you pass should be the folder that contains the ``$ting``
   folder.

## Attention

The TING pen is not supported anymore.
Thus, a project named <https://www.ting-el-tangel.de[Tingel> Tangel] has formed to conserve the old books and provide them for download.
The download script has thus been updated accordingly.

## Contributors

- Ralf Meyer <https://github.com/ralfdonald>
- Bernd Wurst <https://github.com/bwurst>
- Stefan Dangl <https://github.com/stangls>
- frog23 <https://github.com/frog23>
- Florian Brucker <https://github.com/torfsen>
