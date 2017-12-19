#!/usr/bin/env sh

terraform apply -auto-approve
IP=`terraform output | grep IP | awk '{print $3}'`
sleep 15
ssh root@${IP} tail -f /var/log/cloud-init-output.log
