#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
bash "./bin/check-dependencies.sh"
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
  cat "$file" | ./bin/json/jq-linux64 ".$key"  | sed 's/["]//g';
elif [ "$machine" == "Mac" ];
then
    chmod +x ./bin/json/jq-osx-amd64
  cat "$file" | ./bin/json/jq-osx-amd64 ".$key"  | sed 's/["]//g';
else
  echo "ERROR: No JSON library for platform $machine"
fi
