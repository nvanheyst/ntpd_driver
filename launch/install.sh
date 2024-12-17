#!/bin/bash

WORKDIR=$(pwd)

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


sudo systemctl daemon-reload
sudo systemctl enable ntpd_service.service
sudo systemctl start ntpd_service.service

echo "Service ntpd_service.service has been installed and started successfully."
