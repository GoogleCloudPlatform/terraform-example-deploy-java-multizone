project_id=$1

gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"
bucketName=tf-backend-xwiki-gce-`gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"`

gcloud storage buckets describe gs://$bucketName
status=$?
if [ $status -eq 0 ]; then
        echo "bucket exists"
else
        echo "bucket does not exist. Creating bucket by gcloud command."
        gcloud storage buckets create gs://$bucketName
fi
