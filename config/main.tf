module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  disable_services_on_destroy = false
  project_id                  = var.project_id

  activate_apis = [
    "run.googleapis.com",
    "iam.googleapis.com",
    "file.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudbuild.googleapis.com",
  ]
}

module "networking" {
  source = "./tf_modules/networking"

  project_id             = var.project_id
  region                 = var.region
  internal_addresses     = var.internal_addresses
  firewall_source_ranges = var.firewall_source_ranges
}

module "database" {
  source = "./tf_modules/database"

  project_id        = var.project_id
  region            = var.region
  availability_type = var.availability_type
}

module "file_store" {
  source = "./tf_modules/file-store"

  region = var.region
}

data "google_service_account" "cloudbuild_service_account" {
  account_id = "cloudbuild-xwiki-gce"
}

resource "google_storage_hmac_key" "key" {
  service_account_email = data.google_service_account.cloudbuild_service_account.email
}

module "vm" {
  source = "./tf_modules/vm"

  region     = var.region
  project_id = var.project_id
  service_account = {
    email = "${var.vm_sa_email}"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
  startup_script = templatefile(
    "${path.module}/../tools/startup_script.tftpl",
    {
      db_ip         = "${module.database.db_ip}",
      file_store_ip = "${module.file_store.file_store_ip}",
    }
  )
  jgroup_bucket_access_key = google_storage_hmac_key.key.access_id
  jgroup_bucket_secret_key = google_storage_hmac_key.key.secret
}

module "load_balancer" {
  source = "./tf_modules/load-balancer"

  vm1        = module.vm.instance1
  vm2        = module.vm.instance2
  project_id = var.project_id
  region     = var.region
  template   = module.vm.template
  lb_ip      = module.networking.global_addresses[0]
}