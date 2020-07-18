#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "$parent_path/../check-dependencies.sh"
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
sh "$parent_path/../json/write.sh" -f "$parent_path/../../config/$scope.json" -k "$key" -v "$value"
