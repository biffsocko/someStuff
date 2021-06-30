#!/bin/sh
######################################################
# Murphy  - trmurphy@protonmail.com
# mkcd4sfc.sh
#
#
# downloads sfc drivers for ubuntu and creates cdrom
# mount the outpout iso file as a cdrom via the hp ilo
# and install:  apt install *deb
# then, just run "modprobe sfc"
######################################################

# place to dump the files
DIR="/tmp/foo.$$"

# install the package to build an iso file
cat /etc/*release | grep Ubuntu > /dev/null 2>&1
if [ $? -eq 0 ]
then
    # ubuntu
    apt -y install wget
	apt -y install git
	apt -y install mkisofs
else	
    # CentOS/RHEL
    yum -y install wget
    yum -y install git
    yum -y install mkisofs
fi


if [ ! -d ${DIR} ]
then
    mkdir ${DIR}
fi


###############################
# download the files
###############################
cd ${DIR}
wget http://mirrors.kernel.org/ubuntu/pool/main/d/dkms/dkms_2.2.0.3-2ubuntu11_all.deb
if [ $? -ne 0 ]
then 
     logger "$0 failed to download dkms from ubuntu .. exiting"
	 exit 1
fi	 

git clone https://github.com/hoag/sfc-dkms-deb.git
if [ $? -ne 0 ]
then   
    logger "$0 failed to clone sfc-dkms .. exiting"
    exit 1
fi	

###############################
# copy the file we got from git
# into the correct directory
###############################
cp sfc-dkms-deb/*.deb ${DIR}
cd /tmp

#
# Let's make an iso file!
#
mkisofs -o sfc4ubuntu.iso ${DIR}
if [ $? -eq 0 ]
then 
    echo "success .. file located at:"
    ls -l /tmp/sfc4ubuntu.iso
	exit 0
else
    logger "$0 failed to create /tmp/sfc4ubuntu.iso .. exiting"
    echo "$0 failed to create /tmp/sfc4ubuntu.iso .. exiting"
	exit 1
fi	 

