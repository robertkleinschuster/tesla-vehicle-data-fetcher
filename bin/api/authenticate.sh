#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "./bin/check-dependencies.sh"
[ $? -eq 0 ] || exit 1

while getopts ":r" opt; do
  case $opt in
    r) refresh="true"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ "$refresh" == "true" ]
then
  refresh_token=$(sh "./bin/config/read.sh" -s api -k refresh_token)
  [ $? -eq 0 ] || exit 1
  if [ "$refresh_token" != 'null' ] && [ "$refresh_token" ]
  then
    response=$(curl -s -H "Content-Type: application/json" -d "{\"grant_type\" : \"refresh_token\", \"refresh_token\" : \"$refresh_token\"}" https://owner-api.teslamotors.com/oauth/token?grant_type=refresh_token)
  else
    echo "ERROR: No refresh_token"
    exit 1
  fi

else
  email=$1
  password=$2
  client_id=$(sh "./bin/config/read.sh" -s api -k client_id)
  [ $? -eq 0 ] || exit 1
  client_secret=$(sh "./bin/config/read.sh" -s api -k client_secret)
  [ $? -eq 0 ] || exit 1
  response=$(curl -s -H "Content-Type: application/json" -d "{\"grant_type\" : \"password\", \"client_id\" : \"$client_id\", \"client_secret\" : \"$client_secret\", \"email\" : \"$email\", \"password\" : \"$password\"}" https://owner-api.teslamotors.com/oauth/token)
fi

error=$(echo "${response}" | jq -r '.error')
error_description=$(echo "${response}" | jq -r '.error_description')
access_token=$(echo "${response}" | jq -r '.access_token')
refresh_token=$(echo "${response}" | jq -r '.refresh_token')
if [ "$access_token" != "null" ] && [ "$refresh_token" != 'null' ]
then
  sh "./bin/config/write.sh" -s "api" -k "refresh_token" -v "$refresh_token"
  [ $? -eq 0 ] || exit 1
  sh "./bin/config/write.sh" -s "api" -k "access_token" -v "$access_token"
  [ $? -eq 0 ] || exit 1
  exit 0
else
    echo "ERROR: $error_description"
    exit 1
fi
