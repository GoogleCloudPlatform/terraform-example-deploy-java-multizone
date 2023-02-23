PROJECT_ID=$1
REGION=$2
ZONE1=$3
ZONE2=$4

if [ -z $PROJECT_ID ]; then
  echo "Error: 'PROJECT_ID' is required"
  exit 1
elif [ -z $REGION ] || [ $REGION = "global" ]; then
  echo "Error: 'REGION' is required, and it cannot be set to 'global'"
  exit 1
elif [ -z $ZONE1 ] || [ -z $ZONE2 ]; then
  echo "Error: 'ZONE' is required"
  exit 1
elif [[ $ZONE1 != $REGION* ]] || [[ $ZONE2 != $REGION* ]]; then
  echo "Error: 'ZONE' should depend on chosen 'REGION'"
  exit 1
fi
