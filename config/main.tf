module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  disable_services_on_destroy = false
  project_id                  = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "file.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}

locals {
  xwiki_vm_tag       = "xwiki-${var.location["region"]}-autoscale"
  xwiki_lb_port_name = "xwiki-bkend-port"
}

module "networking" {
  depends_on = [
    module.project_services
  ]
  source                 = "./tf_modules/networking"
  project_id             = var.project_id
  region                 = var.location["region"]
  firewall_source_ranges = var.firewall_source_ranges
  xwiki_vm_tag           = local.xwiki_vm_tag
}

module "database" {
  depends_on = [
    module.project_services
  ]
  source                  = "./tf_modules/database"
  xwiki_sql_user_password = var.xwiki_sql_user_password
  project_id              = var.project_id
  region                  = var.location["region"]
  zones                   = var.location["zones"]
  private_network         = module.networking.xwiki_private_network
  availability_type       = var.availability_type
}

module "filestore" {
  depends_on = [
    module.project_services
  ]
  source          = "./tf_modules/filestore"
  region          = var.location["region"]
  zone            = var.location["zones"][0]
  private_network = module.networking.xwiki_private_network
}

data "google_project" "project" {}

resource "google_service_account" "jgroup" {
  depends_on = [
    module.project_services
  ]
  account_id = "xwiki-jgroup"
}

resource "google_project_iam_member" "jgroup_permission" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.jgroup.email}"
}

resource "google_storage_hmac_key" "jgroup" {
  service_account_email = google_service_account.jgroup.email
}

resource "google_storage_bucket" "xwiki_jgroup" {
  depends_on = [
    module.project_services
  ]
  project       = var.project_id
  name          = "xwiki-jgroup-${data.google_project.project.number}"
  location      = var.location["region"]
  force_destroy = true
}

module "vm" {
  depends_on = [
    module.project_services
  ]
  source = "./tf_modules/vm"

  region          = var.location["region"]
  zones           = var.location["zones"]
  private_network = module.networking.xwiki_private_network
  xwiki_vm_tag    = local.xwiki_vm_tag
  project_id      = var.project_id
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
    "./templates/startup_script.tftpl",
    {
      db_ip                    = "${module.database.db_ip}",
      file_store_ip            = "${module.filestore.filestore_ip}",
      xwiki_db_username        = module.database.xwiki_user.name
      xwiki_db_password        = module.database.xwiki_user.password
      jgroup_bucket_name       = google_storage_bucket.xwiki_jgroup.name,
      jgroup_bucket_access_key = google_storage_hmac_key.jgroup.access_id,
      jgroup_bucket_secret_key = google_storage_hmac_key.jgroup.secret,
    }
  )
  xwiki_lb_port_name = local.xwiki_lb_port_name
  xwiki_img_info     = var.xwiki_img_info
  jgroup_bucket_info = {
    access_key = google_storage_hmac_key.jgroup.access_id
    secret_key = google_storage_hmac_key.jgroup.secret
  }
}

module "load_balancer" {
  depends_on = [
    module.project_services
  ]
  source = "./tf_modules/load-balancer"

  project_id         = var.project_id
  region             = var.location["region"]
  xwiki_mig          = module.vm.xwiki_mig
  xwiki_lb_port_name = local.xwiki_lb_port_name
  lb_ip              = module.networking.global_addresses[0]
}

resource "google_monitoring_dashboard" "xwiki" {
  dashboard_json = file("./xwiki_gce_monitor_dashboard.json")
}