#!/usr/bin/env sh

cd "$(dirname "$0")"

terraform destroy -force

cd -
