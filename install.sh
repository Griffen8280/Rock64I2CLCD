#! /bin/bash

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
$SUDO apt update && $SUDO apt install python-smbus git python3 -y

git clone --depth=1 "https://github.com/Leapo/Rock64-R64.GPIO.git"

cd Rock64-R64.GPIO
mv R64 ../
cd ..
rm -Rf Rock64-R64.GPIO

cd R64
chmod +x *.py
cd GPIO
chmod +x *.py
cd ../..
$SUDO cp -R R64 /usr/local/lib/python2.7/dist-packages/

echo "Rock64 GPIO should now be installed"
