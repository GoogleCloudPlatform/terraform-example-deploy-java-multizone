terraform {
  backend "gcs" {
    bucket = "${backend-bucket-name}"
    prefix = "xwiki-cloudbuild-gce"
  }
}
