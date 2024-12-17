#!/bin/bash

# Get the current working directory (this will be the launch folder)
LAUNCH_DIR=$(pwd)

# Remove the systemd service file
echo "Removing systemd service..."
sudo systemctl stop ntpd_service.service
sudo systemctl disable ntpd_service.service
sudo rm /etc/systemd/system/ntpd_service.service

# Reload systemd to reflect the changes
sudo systemctl daemon-reload

# Remove the run script from the launch folder
RUN_SCRIPT="${LAUNCH_DIR}/run_ntpd.sh"
if [ -f "$RUN_SCRIPT" ]; then
    echo "Removing run script..."
    rm "$RUN_SCRIPT"
else
    echo "Run script not found, skipping removal."
fi


echo "Uninstallation complete."
