terraform {
  backend "gcs" {
    bucket = "tf-backend-xwiki-gce-580349825487"
    prefix = "xwiki-cloudbuild-gce"
  }
}
