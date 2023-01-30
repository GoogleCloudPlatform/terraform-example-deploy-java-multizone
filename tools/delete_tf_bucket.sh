
project_id=$1

gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"
bucketName=tf-backend-xwiki-gce-`gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"`

gcloud storage buckets describe gs://$bucketName
status=$?
if [ $status -eq 0 ]; then
        echo "bucket exists, remove all file and delete bucket"
        gcloud storage rm -r gs://$bucketName
else
        echo "bucket not exist"
fi
