resource "google_compute_instance" "xwiki_01t" {
  name             = "g-${var.region}-${var.zone_code1}-xwiki-01t"
  zone             = "${var.region}-${var.zone_code1}"
  machine_type     = "c2-standard-4"
  min_cpu_platform = "Intel Cascade Lake"
  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/${var.xwiki_img_info.image_project}/global/images/${var.xwiki_img_info.image_name}"
      size  = 30
    }
  }
  tags = [
    "g-${var.region}-${var.zone_code1}-xwiki-01t",
  ]
  network_interface {
    network    = "default"
    stack_type = "IPV4_ONLY"
    access_config {
      //Access configurations, i.e. IPs via which this instance can be accessed via the Internet. 
      //Omit to ensure that the instance is not accessible from the Internet.
    }
  }
  service_account {
    email  = var.service_account.email
    scopes = var.service_account.scopes
  }

  metadata_startup_script = var.startup_script
  metadata = {
    jgroup_bucket_access_key = "${var.jgroup_bucket_info.access_key}"
    jgroup_bucket_secret_key = "${var.jgroup_bucket_info.secret_key}"
  }
}

resource "google_compute_instance" "xwiki_02t" {
  name             = "g-${var.region}-${var.zone_code2}-xwiki-02t"
  zone             = "${var.region}-${var.zone_code2}"
  machine_type     = "c2-standard-4"
  min_cpu_platform = "Intel Cascade Lake"

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/beta/projects/${var.xwiki_img_info.image_project}/global/images/${var.xwiki_img_info.image_name}"
      size  = 30
    }
  }
  tags = [
    "g-${var.region}-${var.zone_code2}-xwiki-02t",
  ]
  network_interface {
    network    = "default"
    stack_type = "IPV4_ONLY"
    access_config {
      //Access configurations, i.e. IPs via which this instance can be accessed via the Internet. 
      //Omit to ensure that the instance is not accessible from the Internet.
    }
  }

  service_account {
    email  = var.service_account.email
    scopes = var.service_account.scopes
  }

  metadata_startup_script = var.startup_script
  metadata = {
    jgroup_bucket_access_key = "${var.jgroup_bucket_info.access_key}"
    jgroup_bucket_secret_key = "${var.jgroup_bucket_info.secret_key}"
  }
}

module "google_compute_instance_template" {
  source  = "terraform-google-modules/vm/google///modules/instance_template"
  version = "7.9.0"

  name_prefix      = "g-${var.region}-${var.zone_code1}-xwiki-01t-temp-"
  machine_type     = "c2-standard-4"
  min_cpu_platform = "Intel Cascade Lake"
  source_image     = "https://www.googleapis.com/compute/beta/projects/${var.xwiki_img_info.image_project}/global/images/${var.xwiki_img_info.image_name}"
  disk_size_gb     = 30
  disk_type        = "pd-balanced"
  tags = [
    "g-${var.region}-xwiki-autoscale",
  ]
  network         = "default"
  access_config   = [{
    nat_ip = null
    network_tier = "PREMIUM"
  }]
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
  distribution_policy_zones = [
    "${var.region}-${var.zone_code1}",
    "${var.region}-${var.zone_code2}"
  ]
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
    type                = "tcp"
    port                = 8080
    proxy_header        = "NONE"
    request             = ""
    response            = ""
    check_interval_sec  = 5
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    host                = ""
    initial_delay_sec   = 300
    request_path        = "/"
  }
  named_ports = [
    {
      name = "${var.region}-bkend-port" //same as google_compute_backend_service port_name
      port = 8080
    },
  ]
}