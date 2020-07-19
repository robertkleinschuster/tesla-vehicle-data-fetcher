#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
bash "./bin/check-dependencies.sh"
[ $? -eq 0 ] || exit 1
while getopts ":s:k:" opt; do
  case $opt in
    s) scope="$OPTARG"
    ;;
    k) key="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
bash "./bin/json/read.sh" -f "./data/$scope.json" -k "$key"
[ $? -eq 0 ] || exit 1
