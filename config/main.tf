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
    "servicenetworking.googleapis.com",
  ]
}

module "networking" {
  source = "./tf_modules/networking"

  project_id             = var.project_id
  region                 = var.location["region"]
  zone_code1             = var.location["zone_codes"][0]
  zone_code2             = var.location["zone_codes"][1]
  firewall_source_ranges = var.firewall_source_ranges
}

module "database" {
  depends_on = [
    module.project_services
  ]
  source = "./tf_modules/database"

  project_id        = var.project_id
  region            = var.location["region"]
  zone_code1        = var.location["zone_codes"][0]
  zone_code2        = var.location["zone_codes"][1]
  availability_type = var.availability_type
}

module "file_store" {
  depends_on = [
    module.project_services
  ]
  source = "./tf_modules/file-store"

  region    = var.location["region"]
  zone_code = var.location["zone_codes"][0]
}

# Use exist project service account for jgroup
resource "google_service_account" "jgroups_service_account" {
  account_id = "jgroups-sa-${data.google_project.project.number}"
}

resource "google_project_iam_member" "jgroups_owner_permission" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.jgroups_service_account.email}"
}

resource "google_storage_hmac_key" "jgroup-bucket-key" {
  service_account_email = google_service_account.jgroups_service_account.email
}

module "vm" {
  depends_on = [
    module.project_services
  ]
  source = "./tf_modules/vm"

  region     = var.location["region"]
  zone_code1 = var.location["zone_codes"][0]
  zone_code2 = var.location["zone_codes"][1]
  project_id = var.project_id
  service_account = {
    email = "${var.vm_sa_email}"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/compute",
    ]
  }
  startup_script = templatefile(
    "${path.module}/../tools/startup_script.tftpl",
    {
      db_ip                    = "${module.database.db_ip}",
      file_store_ip            = "${module.file_store.file_store_ip}",
      jgroup_bucket_name       = google_storage_bucket.xwiki-jgroup-bucket.name,
      jgroup_bucket_access_key = google_storage_hmac_key.jgroup-bucket-key.access_id,
      jgroup_bucket_secret_key = google_storage_hmac_key.jgroup-bucket-key.secret,
    }
  )
  xwiki_img_info = var.xwiki_img_info
  jgroup_bucket_info = {
    access_key = google_storage_hmac_key.jgroup-bucket-key.access_id
    secret_key = google_storage_hmac_key.jgroup-bucket-key.secret
  }
}

module "load_balancer" {
  depends_on = [
    module.project_services
  ]
  source = "./tf_modules/load-balancer"

  vm1        = module.vm.instance1
  vm2        = module.vm.instance2
  project_id = var.project_id
  region     = var.location["region"]
  zone_code1 = var.location["zone_codes"][0]
  zone_code2 = var.location["zone_codes"][1]
  template   = module.vm.template
  lb_ip      = module.networking.global_addresses[0]
}

data "google_project" "project" {}

resource "random_id" "random_code" {
  byte_length = 4
}

resource "google_storage_bucket" "xwiki-jgroup-bucket" {
  depends_on = [
    module.project_services
  ]
  project       = var.project_id
  name          = "xwiki-terraform-jgroup-${random_id.random_code.hex}"
  location      = var.location["region"]
  force_destroy = true
}

# Cloud monitor Xwiki HSA dashboard
resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = file("./xwiki_gce_monitor_dashboard.json")
}