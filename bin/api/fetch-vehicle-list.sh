#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "$parent_path/../check-dependencies.sh"
[ $? -eq 0 ] || exit 1
access_token=$(sh "$parent_path/../config/read.sh" -s api -k access_token)
[ $? -eq 0 ] || exit 1
if [ "$access_token" != 'null' ] && [ "$access_token" ]
then
  response=$(curl -s -H "Authorization: Bearer $access_token"  https://owner-api.teslamotors.com/api/1/vehicles)
  echo "${response}" | jq -r '.response'
  exit 0
else
  echo "{\"error\": \"no_authentication\", \"error_description\": \"Run setup.sh to sign in to your tesla account.\"}";
  exit 1
fi
