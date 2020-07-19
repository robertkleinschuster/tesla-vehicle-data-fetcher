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

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "$machine" == "Linux" ]
then
  chmod +x ./bin/json/jq-linux64
./bin/json/jq-linux64 ".$key = \"$value\"" "$file" > "$file.tmp.$$.json" && mv "$file.tmp.$$.json" "$file"
elif [ "$machine" == "Mac" ];
then
    chmod +x ./bin/json/jq-osx-amd64
  ./bin/json/jq-osx-amd64 ".$key = \"$value\"" "$file" > "$file.tmp.$$.json" && mv "$file.tmp.$$.json" "$file"
else
  echo "ERROR: No JSON library for platform $machine"
fi
