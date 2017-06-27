#!/usr/bin/env bash

# figure out script location, append /data
DATA_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/data"

docker run -d -p 49001:8080 -v $DATA_DIR:/var/jenkins_home:z -t jenkins
sleep 10
open http://$(docker-machine env |grep 192|cut -d \/ -f3 |cut -d\: -f1):49001

