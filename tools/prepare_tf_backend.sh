
project_id=$1

gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"
bucketName=tf-backend-xwiki-gce-`gcloud projects list --filter PROJECT_ID=$project_id --format="value(projectNumber)"`

# Generate tf_backend.tf by bucketName
cat << EOF > ../config/tf_backend.tf
terraform {
  backend "gcs" {
    bucket = "$bucketName"
    prefix = "xwiki-cloudbuild-gce"
  }
}
EOF
