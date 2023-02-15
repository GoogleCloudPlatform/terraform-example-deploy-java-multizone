module "google_compute_instance_template" {
  source  = "terraform-google-modules/vm/google///modules/instance_template"
  version = "7.9.0"

  name_prefix      = "g-${var.zones[0]}-xwiki-01t-temp-"
  machine_type     = "c2-standard-4"
  min_cpu_platform = "Intel Cascade Lake"
  source_image     = "https://www.googleapis.com/compute/beta/projects/${var.xwiki_img_info.image_project}/global/images/${var.xwiki_img_info.image_name}"
  disk_size_gb     = 30
  disk_type        = "pd-balanced"
  tags = [
    "g-${var.region}-xwiki-autoscale",
  ]
  network         = "default"
  service_account = {
    email  = var.service_account.email
    scopes = var.service_account.scopes
  }

  startup_script = var.startup_script
}

module "xwiki_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "7.9.0"

  project_id        = var.project_id
  mig_name          = "g-${var.region}-xwiki-group-autoscale"
  hostname          = "g-${var.region}-xwiki-group-autoscale"
  instance_template = module.google_compute_instance_template.self_link
  region            = var.region
  distribution_policy_zones = var.zones
  autoscaling_enabled = true
  max_replicas        = 4
  min_replicas        = 1
  cooldown_period     = 120
  autoscaler_name     = "autoscaler"
  autoscaling_cpu = [
    {
      target = 0.5
    },
  ]
  health_check_name = "xwiki-healthcheck-http-8080"
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
  }
  named_ports = [
    {
      name = "${var.region}-bkend-port" //same as google_compute_backend_service port_name
      port = 8080
    },
  ]
}