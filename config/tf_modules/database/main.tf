resource "google_sql_database_instance" "xwiki_instance" {
  name = "xwiki-${var.region}-db"
  database_version = "MYSQL_8_0"
  region           = var.region
  settings {
    availability_type = var.availability_type
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    location_preference {
      zone           = var.zones[0]
      secondary_zone = var.zones[1]
    }
    tier      = "db-custom-2-4096"
    disk_type = "PD_SSD"
    disk_size = 20
    ip_configuration {
      private_network = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/default"
      ipv4_enabled    = false
    }
  }

  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "xwiki" {
  name      = "xwiki"
  charset   = "utf8"
  collation = "utf8_general_ci"
  instance  = google_sql_database_instance.xwiki_instance.name
}

resource "google_sql_user" "xwiki_user" {
  name     = "xwiki"
  instance = google_sql_database_instance.xwiki_instance.name
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