#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
bash "./bin/check-dependencies.sh"
[ $? -eq 0 ] || exit 1
id=$(bash "./bin/config/read.sh" -s api -k id)
[ $? -eq 0 ] || exit 1
vehicle_data=$(bash "./bin/api/fetch-vehicle-data.sh" "$id")
jq=$(bash ./bin/json/jq-name.sh)
[ $? -eq 0 ] || exit 1
error=$(echo "${vehicle_data}" | $jq -r '.error')
if [ "$error" == "null" ]
then
echo "$vehicle_data" > "./data/vehicle_data.json"
fi
[ $? -eq 0 ] || exit 1
exit 0
