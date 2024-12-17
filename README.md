ntpd\_driver
============

This package exists as a fix for time sync drift on ROS1 Noetic Clearpath Robotics systems using SwiftNav Duro modules. This shouldn't be an issue if a robot is connected to the internet, but if a robot is only used with a base station this can work to fix the sync issue. If you have a Clearpath platform with a Fixposition Vision-RTK-2 / Movella XVN and have a time drift issue, that sensor has an NTP server feature.

The ntpd_driver package was forked to provide: 
- tested instructions specifically for Clearpath platforms
- simpified deployment with a systemd service including an install script

First to check if the platform has a time sync drift issue run this command and it will output a difference between the system software clock and the gps if there is any:

    rostopic echo /sensors/gps_0/fix --filter "print(rospy.get_time()-m.header.stamp.to_sec())"

If there is no output then there is no drift, otherwise the difference will be outputed in seconds. 

System configuration
--------------------

### chrony configuration

Add this to `/etc/chrony/chrony.conf`:

    ### SHM driver
    refclock SHM 0 delay 0.5 refid ROS

And then restart chrony service:

    sudo systemctl restart chrony.service 

### enable passwordless sudo

Edit sudoers file with:

    sudo visudo

Add or modify the %sudo line (consider more secure modifications as needed):

    %sudo   ALL=(ALL:ALL) NOPASSWD: ALL
 

Installation
--------------------

     cd ~
     mkdir -p ntpd_ws/src/
     git clone https://github.com/nvanheyst/ntpd_driver.git
     cd ..
     catkin build

Ensure install script is executable and run install script:

     cd ~/ntpd_ws/src/ntpd_driver/launch/
     chmod +x install.sh
     sudo ./install.sh 
     
Validation
--------------------

check service status:

     sudo systemctl status ntpd_service.service
     
check that time sync was fixed:
     
     rostopic echo /sensors/gps_0/fix --filter "print(rospy.get_time()-m.header.stamp.to_sec())"

Additional tools:
     $sudo journalctl -u ntpd_service.service
     $sudo chronyc sourcestats and/or $sudo chronyc tracking

Testing notes
--------------------

- this was only tested on a Husky Observer
- the robot had password-less sudo enabled
- time was manually changed to be out of sync with $timedatectl set-time ‘YYYY-MM-DD HH:MM:SS’

