PROJECT_ID=$1
REGION=$2
XWIKI_SQL_USER_PASSWORD=$3
ZONE1=$4
ZONE2=$5

if [ -z $PROJECT_ID ]; then
  echo "Error: 'PROJECT_ID' is required"
  exit 1
elif [ -z $REGION ] || [ $REGION = "global" ]; then
  echo "Error: 'REGION' is required, and it cannot be set to 'global'"
  exit 1
elif [ -z $XWIKI_SQL_USER_PASSWORD ]; then
  echo "Error: 'XWIKI_SQL_USER_PASSWORD' is required."
  exit 1
elif [ -z $ZONE1 ] || [ -z $ZONE2 ]; then
  echo "Error: 'ZONE' is required"
  exit 1
elif [[ $ZONE1 != $REGION* ]] || [[ $ZONE2 != $REGION* ]]; then
  echo "Error: 'ZONE' should depend on chosen 'REGION'"
  exit 1
fi
