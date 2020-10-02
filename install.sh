#! /bin/bash

#Check for root and use it when needed
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

#Update the system cache and install needed dependancies for python
$SUDO apt update && $SUDO apt install python-smbus git python3 -y

#Prep and copy the LCD script to bin
chmod +x display_IP.py
$SUDO cp display_IP.py /bin
$SUDO cp screenstartup.conf /etc/systemd

#Setup a check to see if docker is already installed then skip setup if not needed
#Setup the docker subsystem and install Home Assistant/Hass.io Supervisor
if ! command -v docker &> /dev/null
then
    $SUDO apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common network-manager -y
    if [ `lsb_release -cs` == "buster" ]
    then
        curl -fsSL https://download.docker.com/linux/debian/gpg | $SUDO apt-key add -
        $SUDO add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        $SUDO apt update
        $SUDO apt install -y docker-ce
        sleep 3s
    else
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO apt-key add -
        $SUDO add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        $SUDO apt update
        $SUDO apt install -y docker-ce
        sleep 3s
    fi
fi

curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh | bash -s
echo "All done with docker container pull"
echo "Allowing initial startup to complete"
sleep 10s

#reboot the machine for the tools install to take affect
echo "Rebooting machine to finalize setup"
$SUDO reboot  #May not be needed

