#!/bin/bash

release_file=/etc/os-release
logfile=/var/log/updater.log
errorlog=/var/log/updater_errors.log
piholeupdatelog=/var/log/customupdaterpihole.log
piholeupdateerror=/var/log/customupdaterpiholeerror.log

check_exit_status()
{
        if [ $? -ne 0 ]
        then
            echo "An error occured, please check the $errorlog file"
        fi
}

apt-get -y remove nano

if grep -q "debian" $release_file || grep -q "ubuntu" $release_file
then
        # The host is based on Debian,
        # Run the apt version of the command
        sudo apt update 1>>$logfile 2>>$errorlog
        sudo apt dist-upgrade -y 1>>$logfile 2>>$errorlog
        check_exit_status
fi

apt-get install nano
pihole -up 1>>$piholeupdatelog 2>>$piholeupdateerror
check_exit_status
nano -V
echo "Update command ran on $(date)" 1>>$logfile 2>>$errorlog
