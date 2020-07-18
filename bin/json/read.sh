#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
sh "$parent_path/../check-dependencies.sh"
[ $? -eq 0 ] || exit 1
while getopts ":f:k:" opt; do
  case $opt in
    f) file="$OPTARG"
    ;;
    k) key="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
cat "$file" | jq ".$key"  | sed 's/["]//g';
