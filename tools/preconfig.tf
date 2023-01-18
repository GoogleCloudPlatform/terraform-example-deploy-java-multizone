module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  disable_services_on_destroy = false
  project_id                  = var.project_id

  activate_apis = [
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "file.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

resource "random_id" "random" {
  byte_length = 4
}

resource "google_storage_bucket" "infra_state" {
  name     = "tf-backend-xwiki-gce-${var.project_number}"
  location = "US"
}

module "xwiki" {
  depends_on = [
    module.project_services
  ]

  source               = "./modules/source-repository"
  project_id           = var.project_id
  region               = var.region
  repository_name      = var.repository_name
  service_account_name = var.service_account_name
}

