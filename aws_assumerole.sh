#!/bin/bash -i

role_unset() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_SESSION_EXPIRY
    unset AWS_ROLE
    unset AWS_DEFAULT_PROFILE
}

role_status() {
  TIMELEFT=0
  # Added support for Mac with coreutils package installed via brew
  if [ -e "/usr/local/bin/gdate" ]
  then
    DATE=gdate
  else
    DATE=date
  fi

  if [ "$AWS_SESSION_EXPIRY" != "" ]
  then
    EXPEPOCH=$("$DATE" --date "$AWS_SESSION_EXPIRY" +%s)
    NOWEPOCH=$("$DATE" +%s)
    TIMELEFT=$(($EXPEPOCH - $NOWEPOCH))

    if [ "$TIMELEFT" -gt 0 ]
    then
      echo
      echo "assumed_role:$AWS_DEFAULT_PROFILE:$ROLE(expires in "$TIMELEFT"s) "
    else
      role_unset
      echo "Role of $ROLE_ARN expired"
    fi
  fi
}

assume() {
  USAGE="Usage: assume [-p name] [list|role user mfa_token]"
  ([ "$1" != 'list' ] && ([ "$2" == '' ] || [ "$3" == '' ] ) ) && echo $USAGE && return

  PROFILE='default'
  local OPTIND arg a
  while getopts ":p:" arg; do
    case "${arg}" in
      p)
        PROFILE=${OPTARG}
        shift
        shift
        ;;
      *)
        echo $USAGE
        exit 0
        ;;
    esac
  done

  ROLES=$(aws iam list-roles --profile=$PROFILE|grep Arn|cut -d'"' -f4)
  [ "$1" == 'list' ] && echo "$ROLES" && return

  ROLE="$1"
  USER="$2"
  MFA_TOKEN="$3"

  ROLE_ARN=$(echo "$ROLES"|grep -w "role/$ROLE$")
  MFA_SERIAL_NUMBER=$(echo $ROLE_ARN|cut -d':' -f-5):mfa/$USER

  SESSION=$(aws sts assume-role --profile=$PROFILE --role-arn "$ROLE_ARN" --role-session-name s3-access-example --serial-number "$MFA_SERIAL_NUMBER" --token-code "$MFA_TOKEN")

  if [ "$SESSION" != "" ]
  then
      export AWS_ACCESS_KEY_ID=$(echo "$SESSION"|grep AccessKeyId|cut -d'"' -f 4)
      export AWS_SECRET_ACCESS_KEY=$(echo "$SESSION"|grep SecretAccessKey|cut -d'"' -f 4)
      export AWS_SESSION_TOKEN=$(echo "$SESSION"|grep SessionToken|cut -d'"' -f 4)
      export AWS_SESSION_EXPIRY=$(echo "$SESSION"|grep Expiration|cut -d'"' -f 4)
      export AWS_ROLE=$ROLE
      export AWS_DEFAULT_PROFILE=$PROFILE

      PROMPT_COMMAND=role_status

      echo "Assuming role of $ROLE_ARN until [$AWS_SESSION_EXPIRY]"
  else
      echo "Fail to assume the role"
  fi
}

