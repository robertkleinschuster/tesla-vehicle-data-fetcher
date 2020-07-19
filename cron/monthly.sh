#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $parent_path
cd ..
bash "$parent_path/../bin/api/authenticate.sh" -r
