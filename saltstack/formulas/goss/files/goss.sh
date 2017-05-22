#!/usr/bin/env bash

GOSS="/usr/local/bin/goss"
GOSS_FILE="/opt/goss/goss.yaml"
PORT="8080"
ENDPOINT="healthz"
FORMAT="nagios_verbose"
CACHE="5s"

function help {
  echo "Incorrect usage."
  echo
  echo "USAGE:"
  echo "  $0 [-g GOSS_FILE] [-p PORT ] [-e ENDPOINT ]  [-f FORMAT]"
  echo
  echo "OPTIONS:"
  echo "  -g value    File to start tests from (default: goss.yaml)"
  echo "  -p value    Port on which HTTP endpoint should be exposed (default: 8080)"
  echo "  -e value    Endpoint name to expose (default: "healthz")"
  echo "  -f value    Format to output in, valid options: [documentation json junit nagios nagios_verbose rspecish tap] (default: "tap")"
  echo "  -c value    Time to cache the results (default: 5s)"
  echo
  exit 0
}

while getopts ":p:e:g:f:c:" opt; do
  case $opt in
    g)
      GOSS_FILE=$OPTARG
      ;;
    h)
      help
      ;;
    p)
      PORT=$OPTARG
      ;;
    e)
      ENDPOINT=$OPTARG
      ;;
    f)
      FORMAT=$OPTARG
      ;;
    c)
      CACHE=$OPTARG
      ;;
    \?)
      help
      ;;
    :)
      help
      ;;
  esac
done

$GOSS -g $GOSS_FILE serve -l :${PORT} -e /${ENDPOINT} -f ${FORMAT} -c ${CACHE} &
exit $?
