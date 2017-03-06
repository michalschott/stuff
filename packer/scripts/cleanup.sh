#!/bin/sh

echo '### cleaning ssh fingerprints'
rm -f /etc/ssh/ssh_host_*

echo '### cleaning udev rules'
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo '### cleaning up eth0 HWADDR and UUID'
if [ -r /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
fi

echo '### removing old kernels and rescue images'
package-cleanup --oldkernels --count=2 -y
yum remove -y dracut-config-rescue

echo '### cleaning yum cache'
yum clean all

echo '### forcing logrotate and cleaning logs'
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*

echo '### zeroing disk'
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
