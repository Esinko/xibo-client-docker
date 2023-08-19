#!/bin/bash

# Original docker-wine entrypoint
# /usr/bin/entrypoint & 

# Debugging version for cache flush verification
# echo " -> 012"

# Constants
BASE="/xibo-wine"
INSTALLATION_DIRECTORY="$BASE/.wine/drive_c/Program Files (x86)/Xibo Player/"
FIRST_ARGUMENT=$1

# Variables
INSTALLED="0"

# Link .wine to volume
export HOME="$BASE"

# Set WINE's Windows version
if [[ ! -f $BASE/.configured ]]; then
    echo " -> Running one-time WINE configuration update ..."
    winecfg -v win10 &> /dev/null
    WINEDEBUG=-all wine cmd /c exit # Starts and updates WINE configuration then exits
    echo disable > $BASE/.wine/.update-timestamp # Disables further automatic WINE configuration updates
    touch $BASE/.configured
    echo "    Done."
fi

# Run installer?
if [[ ! -d "$INSTALLATION_DIRECTORY" || $FIRST_ARGUMENT == "-i" ]]; then
    echo " -> Running the Player Installer program ..."
    WINEDEBUG=-all wine ./xibo-client-v3-R301.1-win32-x86.msi # TODO: Quiet install does not work with WINE. Why? /qn does nothing (even with msiexec)
    echo "    Installer exited with code $?"
    INSTALLED="1"
fi

# Check installation result
if [[ $INSTALLED == "1" ]]; then
    # Check if files exist
    if [ -f "$INSTALLATION_DIRECTORY/XiboClient.exe" ]; then
        echo "    Installation successful!"
    else
        # Attempt to detect error code
        case $INSTALLER_EXIT_CODE in
            91)
                echo "    Failed to run installer due to WINE runtime error."
            ;;
            53)
                echo "    Installer download failed."
            ;;
            66)
                echo "    Installation canceled."
            ;;
            67)
                echo "    Installation conditions not met."
            ;;
            0)
                echo "    Installer terminated."
            ;;
            *)
                echo "    Generic installation failure."
            ;;
        esac
        exit 1
    fi
fi

# Disable the watchdog (silent)
# The watchdog program does not work with wine at all, for some unknown reason.
if [[ -f "$INSTALLATION_DIRECTORY/watchdog/x64/XiboClientWatchdog.exe" ]]; then
    mv "$INSTALLATION_DIRECTORY/watchdog/x64/XiboClientWatchdog.exe" "$INSTALLATION_DIRECTORY/watchdog/x64/DXiboClientWatchdog.exe" >> /dev/null
    mv "$INSTALLATION_DIRECTORY/watchdog/x86/XiboClientWatchdog.exe" "$INSTALLATION_DIRECTORY/watchdog/x86/DXiboClientWatchdog.exe" >> /dev/null
fi

# Run options?
if [[ $FIRST_ARGUMENT == "-o" || $INSTALLED == "1" ]]; then
    echo " -> Running the Player Options program ..."
    WINEDEBUG=-all wine "$INSTALLATION_DIRECTORY/XiboClient.exe" o
    echo "    Options exited with code $?"
    exit
fi

# Run the player as is
echo " -> Starting the player ..."
WINEDEBUG=-all wine "$INSTALLATION_DIRECTORY/XiboClient.exe"
echo "    Player exited with code $?"
