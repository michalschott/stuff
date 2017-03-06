#!/bin/sh

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

yum upgrade -y ca-certificate
update-ca-trust force-enable
yum update -y
yum install -y yum-utils
