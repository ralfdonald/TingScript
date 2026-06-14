#!/bin/bash

DOWNLOAD_PREFIX="http://13.80.138.170/book-files"
DOWNLOAD_PREFIX_GET_ID="$DOWNLOAD_PREFIX/get/id"
DOWNLOAD_PREFIX_GET_DESCRIPTION_ID="$DOWNLOAD_PREFIX/get-description/id"
DOWNLOAD_AREA_EN_TYPE="area/en/type"
DOWNLOAD_POSTFIX="sn/5497559973888/"

TING="${1}"
if [ -z "${1}" ]; then
  TING="$(grep '/TING\s' /proc/mounts | cut -d ' ' -f 2)"
  if ! [ -d "${TING}/\$ting" ]; then
    TING=
  fi
fi

if [ -z "${TING}" ]; then
  echo "TING konnte nicht automatisch erkannt werden. Bitte gib den Mount-Point des TING-Stifts als Parameter mit."
  echo "Usage: $0 [Ort des \$ting-Ordners]"
  exit 1
fi

tingPath="$TING"

pngEnd="_en.png"
txtEnd="_en.txt"
oufEnd="_en.ouf"
scrEnd="_en.script"

# entfernt ^M aus Datei und schreibt die Zeilen neu
cleanFile() {
  echo "Säubere File $1"
  while read -r line; do
    echo -n "$line" | tr -d $'\r' | grep "[0-9]" >>"TBD_TEMP.TXT"
  done <"$filename"
  rm "$1"
  sort -u TBD_TEMP.TXT >"$1"
  rm TBD_TEMP.TXT
  echo ""
}

# leert die ganze Datei
emptyFile() {
  echo "Leere File $1"
  echo ""
  truncate --size=0 "$1"
}

checkFiles() {
  echo "Prüfe Datei $3"
  thumbMD5=$(grep "ThumbMD5:" "$3" | grep -ow "[0-9a-z]*")
  # shellcheck disable=SC2001
  s="$(echo "$1" | sed 's/^0*//')"
  if [ -z "$thumbMD5" ]; then
    echo "Kein Vorschaubild notwendig"
  else
    echo "Downloade Vorschaubild $1$pngEnd"
    wget "$DOWNLOAD_PREFIX_GET_ID/$s/$DOWNLOAD_AREA_EN_TYPE/thumb/$DOWNLOAD_POSTFIX" -O "$2/$1$pngEnd"
  fi

  fileMD5=$(grep "FileMD5:" "$3" | grep -ow "[0-9a-z]*")
  if [ -z "$fileMD5" ]; then
    echo "Kein Buchfile notwendig"
  else
    echo "Downloade Buchfile $1$oufEnd"
    wget "$DOWNLOAD_PREFIX_GET_ID/$s/$DOWNLOAD_AREA_EN_TYPE/archive/$DOWNLOAD_POSTFIX" -O "$2/$1$oufEnd"
  fi
  scriptMD5=$(grep "ScriptMD5:" "$3" | grep -ow "[0-9a-z]*")
  if [ -z "$scriptMD5" ]; then
    echo "Kein Scriptfile notwendig"
  else
    echo "Downloade Scriptfile $1$scrEnd"
    wget "$DOWNLOAD_PREFIX_GET_ID/$s/$DOWNLOAD_AREA_EN_TYPE/script/$DOWNLOAD_POSTFIX" -O "$2/$1$scrEnd"
  fi

  echo ""
}

getInfo() {
  # shellcheck disable=SC2001
  s="$(echo "$1" | sed 's/^0*//')"
  echo "short: $s"
  wget $DOWNLOAD_PREFIX_GET_DESCRIPTION_ID/"$s"/$DOWNLOAD_AREA_EN_TYPE/$DOWNLOAD_POSTFIX -O "$2"/"$1""$3"
}

getFiles() {
  bookId=$1
  echo "Lade BuchId $bookId"
  getInfo "$bookId" "$2" "$txtEnd"
  checkFiles "$bookId" "$2" "$2/$1$3$txtEnd"
  echo ""
}

echo "Ort des \$ting-Ordner: $tingPath"

filename="$tingPath/\$ting/TBD.TXT"
if ! [ -f "$filename" ]; then
  filename="$tingPath/\$ting/tbd.txt"
fi

if [ "$(wc -l "$filename" | cut -d ' ' -f 1)" == 0 ]; then
  echo 'Kein fehlendes Buch gefunden.'
  exit 0
fi

cleanFile "$filename"

while read -r line; do
  bookId="$(echo -n "$line" | tr -d $'\r' | grep "[0-9]")"
  export bookId
  getFiles "$bookId" "$tingPath/\$ting"

done <"$filename"

emptyFile "$filename"
