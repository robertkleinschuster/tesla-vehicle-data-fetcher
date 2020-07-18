#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "$parent_path/../check-dependencies.sh"
[ $? -eq 0 ] || exit 1
access_token=$(sh "$parent_path/../config/read.sh" -s api -k access_token)
[ $? -eq 0 ] || exit 1
id=$(echo "$1" | xargs)
if [ "$id"  == '' ] || [ "$id"  == 'null' ]
then
  echo "{\"error\": \"no_id\"}";
  exit 1;
fi
if [ "$access_token" != 'null' ] && [ "$access_token" ] && [ "$id" != 'null' ] && [ "$id" ]
then
  response=$(curl -s -H "Authorization: Bearer $access_token" "https://owner-api.teslamotors.com/api/1/vehicles/$id/vehicle_data")
  data=$(echo "${response}" | jq -r '.response')
  if [ "$data" == "null" ]
  then
      echo "{\"error\": \"invalid_id\", \"error_description\": \"no vehicle for id '$id'\"}";
  exit 1
  else
    echo "$data"
  fi
  exit 0
else
  echo "{\"error\": \"no_authentication\"}";
  exit 1
fi
