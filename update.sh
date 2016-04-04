#! /bin/sh
#set path to folder store source code
export SRC_PATH=/home/public/Desktop/linux_bsp
export SUB_PATH=${SRC_PATH}/${bsp_type}

echo "Download src for ${bsp_type}!"
echo "Go to ${SRC_PATH}"
cd ${SRC_PATH}

if [ ! -d ${bsp_type} ]; then

    mkdir ${bsp_type}

    #git clone http://sw-stash.freescale.net/scm/alb/${bsp_type}.git
    #http://sw-stash.freescale.net/scm/alb/linux.git
    #http://sw-stash.freescale.net/scm/alb/u-boot.git
    #http://sw-stash.freescale.net/scm/alb/buildroot.git

    if [ ! -d ${bsp_type} ]; then
        echo "Can not download source code for ${bsp_type}!"
        cd -
        exit 1
    fi

else

    cd ${bsp_type}
    git pull

fi
cd -
exit 0
