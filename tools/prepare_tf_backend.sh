PROJECT_ID=$1

gcloud projects list --filter PROJECT_ID=$PROJECT_ID --format="value(projectNumber)"
BUCKET_NAME=tf-backend-xwiki-gce-`gcloud projects list --filter PROJECT_ID=$PROJECT_ID --format="value(projectNumber)"`

# Generate tf_backend.tf by BUCKET_NAME
cat << EOF > ../config/tf_backend.tf
terraform {
  backend "gcs" {
    bucket = "$BUCKET_NAME"
    prefix = "xwiki/infra"
  }
}
EOF
