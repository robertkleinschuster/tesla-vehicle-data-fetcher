#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "./bin/check-dependencies.sh"
[ $? -eq 0 ] || exit 1
while getopts ":s:k:v:" opt; do
  case $opt in
    s) scope="$OPTARG"
    ;;
    k) key="$OPTARG"
    ;;
    v) value="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
sh "./bin/json/write.sh" -f "./config/$scope.json" -k "$key" -v "$value"
