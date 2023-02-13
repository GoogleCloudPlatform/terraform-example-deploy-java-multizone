DATADOG_API_KEY=$1
DATADOG_APP_KEY=$2

  ###################
  ### enable api ####
  ###################
gcloud services enable cloudbuild.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable servicenetworking.googleapis.com
# For packer
gcloud services enable compute.googleapis.com

  #######################
  ### binding policy ####
  #######################
echo env GOOGLE_CLOUD_PROJECT:$GOOGLE_CLOUD_PROJECT

gcloud_project_number=`gcloud projects list --filter PROJECT_ID=$GOOGLE_CLOUD_PROJECT --format="value(projectNumber)"`
echo gcloud_project_number:$gcloud_project_number

gcloud_cloudbuild_service_account=$gcloud_project_number@cloudbuild.gserviceaccount.com
echo gcloud_cloudbuild_service_account:$gcloud_cloudbuild_service_account

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
    --member=serviceAccount:$gcloud_cloudbuild_service_account \
    --role=roles/owner

  #######################
  ### upload secret #####
  #######################

var1=$(gcloud secrets describe DATADOG_API_KEY 2>/dev/null)
if [ -z "$var1" ]; then
  echo "DATADOG_API_Key does not exist in Secret Manager. Creating key by gcloud command."
  echo -n ${DATADOG_API_KEY} | gcloud secrets create DATADOG_API_KEY  --data-file=-
else
  echo "DATADOG_API_KEY exists"
fi

var2=$(gcloud secrets describe DATADOG_APP_KEY 2>/dev/null)
if [ -z "$var2" ]; then
  echo "DATADOG_APP_Key does not exist in Secret Manager. Creating key by gcloud command."
  echo -n ${DATADOG_APP_KEY} | gcloud secrets create DATADOG_APP_KEY  --data-file=-
else
  echo "DATADOG_APP_KEY exists"
fi