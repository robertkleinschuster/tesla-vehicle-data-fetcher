#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
bash "./bin/check-dependencies.sh"
[ $? -eq 0 ] || exit 1
while getopts ":f:k:v:" opt; do
  case $opt in
    f) file="$OPTARG"
    ;;
    k) key="$OPTARG"
    ;;
    v) value="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
./json/jq ".$key = \"$value\"" "$file" > "$file.tmp.$$.json" && mv "$file.tmp.$$.json" "$file"
