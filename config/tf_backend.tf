terraform {
  backend "gcs" {
    bucket = ${BACKEND_BUCKET_NAME}
    prefix = "xwiki/infrastructure"
  }
}
