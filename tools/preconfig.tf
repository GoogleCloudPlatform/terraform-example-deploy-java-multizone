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

resource "google_storage_bucket" "infra_state" {
  name     = "tf-backend-xwiki-gce-${var.project_number}"
  location = "US"
}

module "pre_config" {
  depends_on = [
    module.project_services
  ]

  source          = "./modules/source-repository"
  project_id      = var.project_id
  region          = var.region
  repository_name = var.repository_name
}

data "google_project" "project" {
}