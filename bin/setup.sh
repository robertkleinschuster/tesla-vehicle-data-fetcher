#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
jq=$(bash ./bin/json/jq-name.sh)
[ $? -eq 0 ] || exit 1
access_token=$(bash "./bin/config/read.sh" -s api -k access_token)
[ $? -eq 0 ] || exit 1
if [ "$access_token" != "null" ]
then
  echo "A configuration already exists."
  while :
do
  read -p "Clear previous configuration? (y/n): " clear
	if [ $clear == "y" ]
	then
	  echo "Clearing previous configuration..."
	  bash "./bin/config/write.sh" -s api -k access_token -v null
	  [ $? -eq 0 ] || exit 1
	  bash "./bin/config/write.sh" -s api -k refresh_token -v null
	  [ $? -eq 0 ] || exit 1
	  bash "./bin/config/write.sh" -s api -k id -v null
	  [ $? -eq 0 ] || exit 1
		break
	elif [ $clear == "n" ]
	then
	  echo "Setup canceled."
	  exit
		break
	fi
done
fi
echo "Please login with your Tesla account."
read -p "E-Mail: " email
read -s -p "Password: " password
bash "./bin/api/authenticate.sh" "$email" "$password"
[ $? -eq 0 ] || exit 1
echo "Loading vehicle list..."
vehiclesJson=$(sh "./bin/api/fetch-vehicle-list.sh")
[ $? -eq 0 ] || exit 1
echo "Available vehicles:"
let index=1
vehicleList=$(echo "${vehiclesJson}" | $jq -r '.[] | @base64');
for row in $vehicleList; do
    _jq() {
     echo ${row} | base64 --decode | $jq -r ${1}
    }
   echo "$index: $(_jq '.display_name'), VIN: $(_jq '.vin')"
   let index++
done
while :
do
  read -p "Please enter the number of the desired vehicle: " number
	if [ $number != '' ] && [ $number -gt 0 ] && [ $number -le $index ]
	then
		break
		else
		  echo "Invalid number given."
	fi
done
id="null"
let index=1
for row in $vehicleList; do
    _jq() {
     echo ${row} | base64 --decode | $jq -r ${1}
    }
    if [ $index -eq $number ]
    then
      id=$(_jq '.id_s')
      echo "Selected: $(_jq '.display_name'), VIN: $(_jq '.vin')"
      break;
    fi
   let index++
done
bash "./bin/config/write.sh" -s api -k id -v "$id"
[ $? -eq 0 ] || exit 1
echo "DONE!";
