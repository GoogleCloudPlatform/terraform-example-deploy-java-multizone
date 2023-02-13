PROJECT_ID=$1
REGION=$2
zone_code1=$3
zone_code2=$4


if [ -z $PROJECT_ID ]; then
  echo "Error: 'PROJECT_ID' is required"
  exit 1
elif [ -z $REGION ] || [ $REGION = "global" ]; then
  echo "Error: '_REGION' is required, and it cannot be set to 'global'"
  exit 1
elif [ -z $zone_code1 ] || [ -z $zone_code2 ]; then
  echo "Error: 'zone_code' is required"
  exit 1
fi  
