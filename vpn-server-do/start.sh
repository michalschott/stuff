#!/usr/bin/env sh

terraform apply
IP=`terraform output | grep IP | awk '{print $3}'`
ssh root@${IP} tail -f /var/log/cloud-init-output.log

