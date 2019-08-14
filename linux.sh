#!/bin/bash

TING="${1}"
if [ -z "${1}" ] ; then
	TING="$(grep '/TING\s' /proc/mounts |cut -d ' ' -f 2)"
	if ! [ -d "${TING}/\$ting" ] ; then
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
cleanFile () {
    echo "Säubere File $1"
    while read -r line
    do
        $(echo -n "$line" | tr -d $'\r' | grep "[0-9]" >> TBD_TEMP.TXT)
    done < "$filename"
    rm $1
    mv TBD_TEMP.TXT $1
    echo ""
}

# leert die ganze Datei
emptyFile () {
    echo "Leere File $1"
    echo ""
    truncate --size=0 $1
}

checkFiles () {
    echo "Prüfe Datei $3";
    thumbMD5=$(cat $3 | grep "ThumbMD5:" | grep -ow "[0-9a-z]*");
    if [ -z $thumbMD5 ]; then
        echo "Kein Vorschaubild notwendig"
    else
        echo "Downloade Vorschaubild $1$pngEnd"
        wget http://system.ting.eu/book-files/get/id/$1/area/en/type/thumb -O $2/$1$pngEnd
    fi

    fileMD5=$(cat $3 | grep "FileMD5:" | grep -ow "[0-9a-z]*")
    if [ -z $fileMD5 ]; then
        echo "Kein Buchfile notwendig"
    else
        echo "Downloade Buchfile $1$oufEnd"
        wget http://system.ting.eu/book-files/get/id/$1/area/en/type/archive -O $2/$1$oufEnd
    fi
    scriptMD5=$(cat $3 | grep "ScriptMD5:" | grep -ow "[0-9a-z]*")
    if [ -z $scriptMD5 ]; then
        echo "Kein Scriptfile notwendig"
    else
        echo "Downloade Scriptfile $1$scrEnd"
        wget http://system.ting.eu/book-files/get/id/$1/area/en/type/script -O $2/$1$scrEnd
    fi

    echo ""
}

getInfo () {
    $(wget http://system.ting.eu/book-files/get-description/id/"$1"/area/en -O "$2"/"$1""$3")
}

getFiles () {
    bookId=$1
    echo "Lade BuchId $bookId"
    getInfo $bookId "$2" $txtEnd
    checkFiles $bookId $2 "$2/$1$3$txtEnd"
    echo ""
}

echo "Ort des \$ting-Ordner: $tingPath"

filename="$tingPath/\$ting/TBD.TXT"
if ! [ -f "$filename" ] ; then
	filename="$tingPath/\$ting/tbd.txt"
fi

if [ "$(wc -l "$filename"|cut -d ' ' -f 1)" == 0 ] ; then
	echo 'Kein fehlendes Buch gefunden.'
	exit 0
fi
	
cleanFile "$filename"

while read -r line
do
    export bookId=$(echo -n "$line" | tr -d $'\r' | grep "[0-9]" | sed 's/^0*//')
    getFiles "$bookId" "$tingPath/\$ting"

done < "$filename"

emptyFile "$filename"
