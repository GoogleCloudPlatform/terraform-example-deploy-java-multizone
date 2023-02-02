project_id=$1
location=$2
zone_code1=$3
zone_code2=$4

if [ -z $project_id ]; then
  echo "Error: 'project_id' is required"
  exit 1
elif [ -z $location ] || [ $location = "global" ]; then
  echo "Error: 'region' is required, and it cannot be set to 'global'"
  exit 1
elif [ -z $zone_code1 ] || [ -z $zone_code2 ]; then
  echo "Error: 'zone_code' is required"
  exit 1
fi  
