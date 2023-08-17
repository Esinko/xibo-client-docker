#!/bin/bash

# Original docker-wine entrypoint
# /usr/bin/entrypoint & 

# Constants
INSTALLATION_DIRECTORY="$HOME/.wine/drive_c/Program Files (x86)/Xibo Player"
FIRST_ARGUMENT=$1

# Variables
INSTALLED=0

# Set wine "mode"
winecfg -v win10 &> /dev/null

# Run installer?
if [[ ! -d "$DIRECTORY" || $FIRST_ARGUMENT == "-i" ]]; then
    echo " -> Running the Player Installer program ..."
    cd /xibo-wine/
    WINEDEBUG=-all wine ./xibo-client-v3-R301.1-win32-x86.msi
    INSTALLED=1
    exit
fi

# Disable the watchdog (silent)
# The watchdog program does not work with wine at all, for some unknown reason.
mv "$INSTALLATION_DIRECTORY/watchdog/x64/XiboClientWatchdog.exe" "$INSTALLATION_DIRECTORY/watchdog/x64/DXiboClientWatchdog.exe" >> /dev/null
mv "$INSTALLATION_DIRECTORY/watchdog/x86/XiboClientWatchdog.exe" "$INSTALLATION_DIRECTORY/watchdog/x86/DXiboClientWatchdog.exe" >> /dev/null

# Run options?
if [[ $FIRST_ARGUMENT == "-o" || $INSTALLED == 1 ]]; then
    echo " -> Running the Player Options program ..."
    WINEDEBUG=-all wine "$INSTALLATION_DIRECTORY/XiboClient.exe" o
    exit
fi

# Run the player as is
echo " -> Starting the player ..."
WINEDEBUG=-all wine "$INSTALLATION_DIRECTORY/XiboClient.exe"
