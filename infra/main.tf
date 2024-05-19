/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  xwiki_vm_tag       = "xwiki-${var.region}-autoscale"
  xwiki_lb_port_name = "xwiki-bkend-port"
  vm_sa_email        = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  zones_base = {
    default = data.google_compute_zones.available.names
    user    = compact(var.zones)
  }
  zones = local.zones_base[length(compact(var.zones)) == 0 ? "default" : "user"]
}

data "google_compute_zones" "available" {
  depends_on = [
    module.project_services
  ]
  project = var.project_id
  region  = var.region
}

module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 15.0"

  disable_services_on_destroy = false
  project_id                  = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "file.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "config.googleapis.com"
  ]
}

module "networking" {
  source = "./modules/networking"

  project_id = var.project_id
  region     = var.region
  firewall_source_ranges = concat(
    [module.load_balancer.lb_global_ip],
    # Health check service ip
    var.firewall_source_ranges
  )
  xwiki_vm_tag = local.xwiki_vm_tag

  depends_on = [
    module.project_services
  ]
}

module "database" {
  source = "./modules/database"

  project_id         = var.project_id
  region             = var.region
  private_network_id = module.networking.xwiki_private_network.id
  availability_type  = var.availability_type
  service_account    = local.vm_sa_email

  depends_on = [
    module.project_services
  ]
}

module "filestore" {
  source = "./modules/filestore"

  zone               = local.zones[0]
  private_network_id = module.networking.xwiki_private_network.id
  labels             = var.labels
  project_id         = var.project_id

  depends_on = [
    module.project_services
  ]
}

data "google_project" "project" {}

resource "google_service_account" "jgroup" {
  account_id = "xwiki-jgroup-gce"
  depends_on = [
    module.project_services
  ]
}

resource "google_project_iam_member" "jgroup_permission" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.jgroup.email}"
}

resource "google_storage_hmac_key" "jgroup" {
  service_account_email = google_service_account.jgroup.email
}

resource "google_storage_bucket" "xwiki_jgroup" {
  project       = var.project_id
  name          = "xwiki-jgroup-${data.google_project.project.number}-gce"
  location      = var.region
  labels        = var.labels
  force_destroy = true
  depends_on = [
    module.project_services
  ]
}

module "vm" {
  source = "./modules/vm"

  region             = var.region
  zones              = local.zones
  private_network_id = module.networking.xwiki_private_network.id
  xwiki_vm_tag       = local.xwiki_vm_tag
  project_id         = var.project_id
  labels             = var.labels
  service_account = {
    email = local.vm_sa_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
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
    "${path.module}/templates/startup_script.tftpl",
    {
      db_ip                    = module.database.db_ip,
      file_store_ip            = module.filestore.filestore_ip,
      xwiki_db_username        = module.database.xwiki_user.name
      gcp_project              = var.project_id
      xwiki_db_password_secret = module.database.password_secret
      jgroup_bucket_name       = google_storage_bucket.xwiki_jgroup.name,
      jgroup_bucket_access_key = google_storage_hmac_key.jgroup.access_id,
      jgroup_bucket_secret_key = google_storage_hmac_key.jgroup.secret,
    }
  )
  xwiki_lb_port_name = local.xwiki_lb_port_name
  xwiki_img_info     = var.xwiki_img_info
  depends_on = [
    module.project_services
  ]
}

module "load_balancer" {
  source = "./modules/load-balancer"

  project_id         = var.project_id
  xwiki_mig          = module.vm.xwiki_mig
  xwiki_lb_port_name = local.xwiki_lb_port_name

  depends_on = [
    module.project_services
  ]
}

resource "google_monitoring_dashboard" "xwiki" {
  dashboard_json = file("${path.module}/files/xwiki_gce_monitor_dashboard.json")
}
