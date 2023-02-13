project_id=$1

gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"
bucketName=tf-backend-xwiki-gce-`gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"`

gcloud storage buckets describe gs://$bucketName
status=$?
if [ $status -eq 0 ]; then
        echo "bucket exists. Removing all files and deleting bucket."
        gcloud storage rm -r gs://$bucketName
else
        echo "bucket does not exist."
fi
