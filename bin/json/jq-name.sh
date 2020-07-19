#!/bin/bash
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
  echo ./bin/json/jq-linux64
elif [ "$machine" == "Mac" ];
then
    chmod +x ./bin/json/jq-osx-amd64
    echo ./bin/json/jq-osx-amd64
else
  echo "ERROR: No JSON library for platform $machine"
  exit 1
fi
