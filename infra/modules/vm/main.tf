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

module "instance_template" {
  source  = "terraform-google-modules/vm/google///modules/instance_template"
  version = "11.1.0"

  project_id       = var.project_id
  name_prefix      = "xwiki-${var.zones[0]}-temp-"
  machine_type     = "n2-standard-2"
  min_cpu_platform = "Intel Cascade Lake"
  source_image     = "https://www.googleapis.com/compute/beta/projects/${var.xwiki_img_info.image_project}/global/images/${var.xwiki_img_info.image_name}"
  disk_size_gb     = 30
  disk_type        = "pd-balanced"
  tags = [
    var.xwiki_vm_tag,
  ]
  network = var.private_network_id
  service_account = {
    email  = var.service_account.email
    scopes = var.service_account.scopes
  }
  startup_script = var.startup_script
  labels         = var.labels
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "11.1.0"

  project_id                = var.project_id
  mig_name                  = "xwiki-${var.region}-group-autoscale"
  hostname                  = "xwiki-${var.region}-group-autoscale"
  instance_template         = module.instance_template.self_link
  region                    = var.region
  distribution_policy_zones = var.zones
  autoscaling_enabled       = true
  max_replicas              = 2
  min_replicas              = 1
  cooldown_period           = 120
  autoscaler_name           = "autoscaler"
  autoscaling_cpu = [
    {
      target            = 0.5,
      predictive_method = null
    },
  ]
  health_check_name = "xwiki-health-check-http-8080"
  health_check = {
    type                = "http"
    port                = 8080
    proxy_header        = "NONE"
    request             = ""
    response            = ""
    check_interval_sec  = 5
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    host                = ""
    initial_delay_sec   = 600
    request_path        = "/xwiki/bin/view/Main"
    enable_logging      = true
  }
  named_ports = [
    {
      name = var.xwiki_lb_port_name
      port = 8080
    },
  ]
}
