#!/usr/bin/env bash

#this file is just for reference

source /opt/ros/noetic/setup.bash
source /home/administrator/ntpd_ws/devel/setup.bash

rosrun ntpd_driver shm_driver _shm_unit:=0 _time_ref_topic:=/swiftnav/position_receiver_0/ros/time_ref
echo "Driver launched"
