#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "./bin/check-dependencies.sh"
[ $? -eq 0 ] || exit 1
id=$(sh "./bin/config/read.sh" -s api -k id)
[ $? -eq 0 ] || exit 1
sh "./bin/api/fetch-vehicle-data.sh" $id > "./bin/data/vehicle_data.json"
[ $? -eq 0 ] || exit 1
exit 0
