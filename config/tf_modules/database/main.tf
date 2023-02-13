resource "google_sql_database_instance" "xwiki_inatance" {
  name = "xwiki-${var.region}-db"
  //root_password    = "1qaz2wsx" // doesn’t work in MySQL
  database_version = "MYSQL_8_0"
  region           = var.region
  settings {
    availability_type = var.availability_type
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    location_preference {
      zone           = "${var.region}-${var.zone_code1}"
      secondary_zone = "${var.region}-${var.zone_code2}" // cannot pass Terraform plan if version < 3.39
    }
    tier      = "db-custom-2-4096" //The machine type 
    disk_type = "PD_SSD"
    disk_size = 20
    ip_configuration {
      private_network = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/default"
      ipv4_enabled    = false
    }
  }

  deletion_protection = false                                                         // in order to destroy by using terraform destroy
  depends_on          = [google_service_networking_connection.private_vpc_connection] // must explicitly add a depends_on
  // if no 'depends_on' set, an error will occur and fail to create an instance because the network doesn’t have at least 1 private service connection.  
  // Please see https://cloud.google.com/sql/docs/mysql/private-ip#network_requirements for how to create this connection.
}

resource "google_sql_database" "xwiki" {
  name      = "xwiki"
  charset   = "utf8"
  collation = "utf8_general_ci"
  instance  = google_sql_database_instance.xwiki_inatance.name
}

resource "google_sql_user" "xwiki_user" {
  name     = "xwiki"
  instance = google_sql_database_instance.xwiki_inatance.name
  password = var.xwiki_sql_user_password
}

resource "google_compute_global_address" "sql_address" {
  name          = "sql-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = "default"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network = "default"
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.sql_address.name,
  ]
}