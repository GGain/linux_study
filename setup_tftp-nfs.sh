#!/bin/bash

echo "This setup is used for ubuntu version 14.04 or newer!"
echo "Please check your ubuntu version before setup!"
echo "Is your version 14.04 or newer?"
read tmp

ERROR=""

# LIST_SOFT='tftp tftpd nfs-kernel-server portmap xinetd isc-dhcp-server'
LIST_SOFT='portmap'

case "$tmp" in
        [yY]|[Yy][Ee][Ss])
				echo "Installing the software needed!!"
                for Soft in $LIST_SOFT
                do
                        if [[ "`dpkg -s $Soft | grep installed`" -eq "" ]]; then
                                echo "Install $Soft";
                                sudo apt-get install $Soft
                                if [[ "`dpkg -s $Soft | grep installed`" = "" ]]; then
                                        echo "$Soft installs unsuccessed!!"
                                fi
                        else
                                echo "$Soft was installed!!"
                                ERROR='${ERROR} $Soft'
                        fi
                done

                ;;
        *)
                 echo -n "Abort!";;
esac

BOOTPATH=/tftpboot
RFSPATH=$(BOOTPATH)/rfs
echo "Insert the root tftp folder where contain the file and store the file for transfer data (recive and transmit) or press enter for default /tftpboot"
read tmp
if [[ "tmp" != '']]; then 
	echo $tmp
	BOOTPATH=$(tmp)
fi

echo "Insert the root file system folder where contain the file and store the file for transfer data (recive and transmit) or press enter for default /tftpboot/rfs"
read tmp
if [[ "tmp" != '']]; then 
	echo $tmp
	RFSPATH=$(BOOTPATH)/$(tmp)
fi

echo "Setup Environment"
if [[ -d /tftpboot ]]; then 
	echo "TFTP folder already existed!"
else
	echo "Make folder tftpboot"
	sudo mkdir /tftpboot
fi

if [[ -d /tftpboot/rfs ]]; then 
	echo "Root file sytem folder already existed!"
else
	echo "Make folder root file sytem (rfs)"
	sudo mkdir /tftpboot/rfs
fi

