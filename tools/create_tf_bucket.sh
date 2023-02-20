PROJECT_ID=$1

gcloud projects list --filter PROJECT_ID=$PROJECT_ID --format="value(projectNumber)"
BUCKET_NAME=tf-backend-xwiki-gce-`gcloud projects list --filter PROJECT_ID=$PROJECT_ID --format="value(projectNumber)"`

gcloud storage buckets describe gs://$BUCKET_NAME
status=$?
if [ $status -eq 0 ]; then
        echo "bucket exists"
else
        echo "bucket does not exist. Creating bucket by gcloud command."
        gcloud storage buckets create gs://$BUCKET_NAME
fi
