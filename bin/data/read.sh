#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "$parent_path/../check-dependencies.sh"
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
sh "$parent_path/../json/read.sh" -f "$parent_path/../../data/$scope.json" -k "$key"
[ $? -eq 0 ] || exit 1
