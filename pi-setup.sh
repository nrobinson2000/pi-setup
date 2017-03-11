#!/bin/bash
#
# pi-setup: Configure a Raspbian SD card for headless use with Particle
#

blue_echo()
{
  echo "$(tput setaf 6)$(tput bold)$1$(tput sgr0)"
}

green_echo()
{
  echo "$(tput setaf 2)$(tput bold)$1$(tput sgr0)"
}

red_echo()
{
  echo "$(tput setaf 1)$(tput bold)$1$(tput sgr0)"
}


HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="setup-pi"
TITLE="Choose Your SD card"
MENU="Make sure to choose the correct option."


ls -1 "/media/$USER" > ls.txt

i=-1 # To make i iterate from 0

while ((i++)); read partition # Generate OPTIONS
do
ipos="$((2 * $i))"
ppos="$(($ipos + 1))"

OPTIONS[$ipos]="$(($i + 1))"
OPTIONS[$ppos]="$partition"

done < ls.txt


echo ${OPTIONS[@]}
echo
echo ${OPTIONS[1]}

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear


case $CHOICE in
        $CHOICE)
            SELECTION="${OPTIONS[2*$CHOICE-1]}"
            # echo "$CHOICE"
            echo
            green_echo "You chose $SELECTION"
            echo
            ls "/media/$USER/$SELECTION"
            ;;
esac
