#! /bin/bash

REGION=$1
XWIKI_SQL_USER_PASSWORD=$2
ZONE1=$3
ZONE2=$4
XWIKI_IMAGE_PROJECT=$5
XWIKI_IMAGE_NAME=$6

if [ -z $XWIKI_IMAGE_PROJECT ]; then
  echo "xwiki project image info empty, set default value"
  XWIKI_IMAGE_PROJECT="migrate-legacy-java-app-gce"
  XWIKI_IMAGE_NAME="us-west1-xwiki-01t-img-efab2b30-5982-4ba0-a115-ffde4eee0434"
fi

cat << EOF > ../config/terraform.tfvars
availability_type = "REGIONAL"
xwiki_sql_user_password = "$XWIKI_SQL_USER_PASSWORD"
firewall_source_ranges = [
  //Health check service ip
  "130.211.0.0/22",
  "35.191.0.0/16",
]
location = {
  region     = "$REGION"
  zones = ["$ZONE1", "$ZONE2"]
}
xwiki_img_info = {
    image_project = "$XWIKI_IMAGE_PROJECT"
    image_name = "$XWIKI_IMAGE_NAME"
}
EOF