sudo apt-get install debootstrap qemu-user-static
#prepare:
ARCH=$1
VER=$2
OUT_DIR=$3
SRC_URL=http://httpredir.debian.org/debian/
ROOT_DIR=${OUT_DIR}debian_${ARCH}_${VER}
QEMU_DIR=.
#step 1:
sudo mkdir ${ROOT_DIR}
sudo debootstrap --foreign --arch ${ARCH} ${VER} ${ROOT_DIR} ${SRC_URL}
if [ "${ARCH}" = "arm64" ] 
then 
sudo cp /usr/bin/qemu-aarch64-static ${ROOT_DIR}/usr/bin/
else
sudo cp /usr/bin/qemu-arm-static ${ROOT_DIR}/usr/bin/
fi

#step 2: 
sudo DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot ${ROOT_DIR} /debootstrap/debootstrap --second-stage
sudo chmod 777 ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb http://ftp.de.debian.org/debian/ ${VER} main" >> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb-src http://ftp.de.debian.org/debian/ ${VER} main" >> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "" >> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb http://security.debian.org/ ${VER}/updates main"	>> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb-src http://security.debian.org/ ${VER}/updates main" >> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb http://http.us.debian.org/debian stable main contrib non-free" >> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb http://non-us.debian.org/debian-non-US stable/non-US main contrib non-free" >> ${ROOT_DIR}/etc/apt/sources.list
sudo echo "deb http://security.debian.org stable/updates main contrib non-free" >> ${ROOT_DIR}/etc/apt/sources.list
sudo chmod 755 ${ROOT_DIR}/etc/apt/sources.list

#we need some config for rootfs to work on real machine
#configure filesystem for target
#-------------------------------
#
#1. Enter emulation environment
#   
#  sudo LC_ALL=C LANGUAGE=C LANG=C chroot debian_armel_wheezy
#
#2. Set a reasonable default date
#
#  echo "#!/bin/sh -e"             > /etc/rc.local
#  echo "date -s \"`date`\""      >> /etc/rc.local
#  echo "exit 0"                  >> /etc/rc.local
#  chmod u+x /etc/rc.local
#
#  Notes: remove leading "exit 0"!
#
#3. Add serial console support
#
#  echo "t0:23:respawn:/sbin/getty -L ttyLF0 115200 vt100" >> /etc/inittab
#
#4. Create entries for proc, then mount proc:
#
#  echo "proc    /proc     proc    defaults 0 0" >> /etc/fstab
#  echo "devpts  /dev/pts  devpts  defaults 0 0" >> /etc/fstab
#
#5. Setup hostname
#
#  echo "debian" > /etc/hostname
#  echo "127.0.0.1 debian" >> /etc/hosts
#
#6. Setup network (optional)
#
#  echo ""                          >> /etc/network/interfaces 
#  echo "## LAN interface"          >> /etc/network/interfaces 
#  echo "auto eth0"                 >> /etc/network/interfaces 
#  echo "iface eth0 inet static"    >> /etc/network/interfaces 
#  echo "    address 10.0.0.100 "  >> /etc/network/interfaces 
#  echo "    netmask 255.255.255.0" >> /etc/network/interfaces 
#  echo "    gateway 10.0.0.1" >> /etc/network/interfaces 
#
#7. Exit the emulation environment
#
#  exit
#
#8. Cleanup history
#
#  sudo rm debian_armel_wheezy/root/.bash_history
#
#
#
#Backup/Restore
#--------------
#
#sudo tar -czpf debian_armel_wheezy-2ndstage-configured.tgz debian_armel_wheezy
#sudo tar -xzpf debian_armel_wheezy-2ndstage-configured.tgz
