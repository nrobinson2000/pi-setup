#!/bin/bash
#
# pi-setup: Configure a Raspbian SD card for headless use with Particle
# This script will need to be run with sudo
# Depends: sshpass

function pause()
{
  read -rp "$*"
}

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

ls -1 "/media/$USER" | grep -vi "boot" > ls.txt

i=-1 # To make i iterate from 0

while ((i++)); read partition # Generate OPTIONS
do
ipos="$((2 * $i))"
ppos="$(($ipos + 1))"

OPTIONS[$ipos]="$(($i + 1))"
OPTIONS[$ppos]="$partition"

done < ls.txt

rm ls.txt


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
            PARTITION="${OPTIONS[2*$CHOICE-1]}" # Set the partition for the Raspbian SD card
            echo
            green_echo "You chose $PARTITION. Is this correct?"
            read -rp "(yes/no): " response
            if [ "$response" == "y" ] || [ "$response" == "Y" ] || [ "$response" == "yes" ] || [ "$response" == "YES" ];
            then
              echo
              blue_echo "Continuing with setup..."
            else
              echo
              red_echo "Aborting..."
              echo
              exit
            fi
            echo
            ls "/media/$USER/$PARTITION"
            echo
            ;;
esac


# Set up wifi

blue_echo "We will now create your Wi-Fi configuration..."
read -rp "SSID: " WIFI_SSID
read -rp "PASSWORD: " WIFI_PASS
echo

echo "network={
    ssid=\"$WIFI_SSID\"
    psk=\"$WIFI_PASS\"
    key_mgmt=WPA-PSK
}" > "wpa_supplicant.conf" #TODO

# Set up hostname

blue_echo "What would you like to set the hostname to?
This will determine its .local mDNS IP."
read -rp "Hostname: " HOSTNAME
echo

echo "$HOSTNAME" > "hostname" #TODO

grep -vi "127.0.1.1" "hosts" > "hosts.new" #TODO
echo "127.0.1.1 $HOSTNAME" >> "hosts.new" #TODO
rm "hosts" #TODO
mv "hosts.new" "hosts" #TODO

# Enable SSH: just create `ssh` in boot parttion

echo "This file enables SSH.  The contents do not matter." > "ssh" #TODO

# Boot the Raspberry Pi and continue via SSH

blue_echo "We will now continue setup over SSH.
Please power on your Raspberry Pi with the SD card and wait until it is online."

pause "Press [ENTER] to continue..."

blue_echo "
Open another terminal window and SSH into your Raspberry Pi:"

green_echo "
        ssh pi@$HOSTNAME.local"

blue_echo "
The default password is \"raspberry\" with no quotes. I suggest that you change
the password. Run the following in your Raspberry Pi Terminal:"

green_echo "
        passwd
"
pause "Press [ENTER] to continue..."

blue_echo "
Next, you should install any available updates for your Raspberry Pi:"

green_echo "
        sudo apt update && sudo apt upgrade
        "

pause "Press [ENTER] to continue..."

blue_echo "
Now you are ready to install Particle on your Raspbery Pi. You will need to
log using your Particle account and claim your Pi to complete the installation.
Run the following to install particle-agent, the Particle firmware daemon:"

green_echo "
        bash <( curl -sL https://particle.io/install-pi )
"

pause "Press [ENTER] to finish..."

green_echo "
Thank you for using my script for expediting headless setup on Raspbery Pi.
The GitHub repo can be found here: https://github.com/nrobinson2000/pi-setup

Your Pi should be connected to the Particle Cloud and running Tinker.

Good luck with your projects!

"






#
