#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "$parent_path/check-dependencies.sh"
[ $? -eq 0 ] || exit 1
id=$(sh "$parent_path/config/read.sh" -s api -k id)
[ $? -eq 0 ] || exit 1
sh "$parent_path/api/fetch-vehicle-data.sh" $id > "$parent_path/../data/vehicle_data.json"
[ $? -eq 0 ] || exit 1
exit 0
