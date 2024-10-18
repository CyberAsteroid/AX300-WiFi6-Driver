#!/bin/bash
Main_version=`uname -r |awk -F'.' '{print $1}'`
Minor_version=`uname -r |awk -F'.' '{print $2}'`
cp -r ./tenda /usr/src
cp /usr/src/tenda/aic8800/aic.rules /etc/udev/rules.d
udevadm trigger
udevadm control --reload
echo "udev done"
if [ -L /dev/aicudisk ]; then
echo "device exist"
eject /dev/aicudisk
else
echo "device not exist"
fi
cd /usr/src/tenda/aic8800/fw/
rm -rf /lib/firmware/aic8800DC
cp -rf /usr/src/tenda/aic8800/fw/aic8800DC /lib/firmware/
echo "cp fw done"
cd /usr/src/tenda/aic8800/drivers/aic8800/
make
if [ $? -ne 0 ]; then
    echo "make failed, install aic8800 wifi drvier failed"
    exit 1
fi
make install
if [ $? -ne 0 ]; then
    echo "make install failed, install aic8800 wifi driver failed"
    exit 1
fi
modprobe cfg80211
insmod /usr/src/tenda/aic8800/drivers/aic8800/aic_load_fw/aic_load_fw.ko
if [ $? -ne 0 ]; then
    echo "insmode aic_load_fw failed, install aic8800 wifi driver failed"
    exit 1
fi
insmod /usr/src/tenda/aic8800/drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko
if [ $? -ne 0 ]; then
    echo "insmod aic8800_fdrv failed, install aic8800 wifi drvier failed"
    exit 1
fi
echo "insmod done"
cd /usr/src/tenda/aic8800/aicrf_test/
make
if [ $? -ne 0 ]; then
    echo "make failed, install aic8800 wifi driver failed"
    exit 1
fi
make install
if [ $? -ne 0 ]; then
    echo "make install failed, install aic8800 wifi driver failed"
    exit 1
fi
echo "Install aic8800 wifi driver successful!!!!!"
exit 0
