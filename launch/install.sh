#!/bin/bash

# Get the current working directory (this will be the workspace)
WORKDIR=$(pwd)

# Create the systemd service file for ntpd_service
cat <<EOF | sudo tee /etc/systemd/system/ntpd_service.service
[Unit]
Description=NTPD ROS Service
After=network.target ros.service

[Service]
Type=simple
User=root
WorkingDirectory=${WORKDIR}
ExecStart=/bin/bash ./ntpd.sh
Restart=on-failure
Environment=ROS_MASTER_URI=http://localhost:11311
Environment=ROS_IP=127.0.0.1
KillMode=control-group
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to register the new service
sudo systemctl daemon-reload

# Enable the service to start at boot
sudo systemctl enable ntpd_service.service

# Start the service immediately
sudo systemctl start ntpd_service.service

echo "Service ntpd_service.service has been installed and started successfully."

# Create the run script in the launch folder
RUN_SCRIPT="${WORKDIR}/src/ntpd_driver/launch/run_ntpd.sh"

cat <<EOF > $RUN_SCRIPT
#!/usr/bin/env bash

# Source ROS and workspace setup
source /opt/ros/noetic/setup.bash
source ${WORKDIR}/devel/setup.bash

# Run the ROS node
rosrun ntpd_driver shm_driver _shm_unit:=0 _time_ref_topic:=/swiftnav/position_receiver_0/ros/time_ref

echo "Driver launched"
EOF

# Make the run script executable
chmod +x $RUN_SCRIPT

echo "Run script created at ${RUN_SCRIPT} and made executable."
