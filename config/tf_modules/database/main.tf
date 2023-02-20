resource "google_sql_database_instance" "xwiki" {
  name             = "xwiki-${var.region}-db"
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
      private_network = "projects/${var.project_id}/global/networks/${var.private_network.name}"
      ipv4_enabled    = false
    }
  }

  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc]
}

resource "google_sql_database" "xwiki" {
  name      = "xwiki"
  charset   = "utf8"
  collation = "utf8_general_ci"
  instance  = google_sql_database_instance.xwiki.name
}

resource "google_sql_user" "xwiki" {
  name     = "xwiki"
  instance = google_sql_database_instance.xwiki.name
  password = var.xwiki_sql_user_password
}

resource "google_compute_global_address" "sql" {
  name          = "xwiki-db-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = var.private_network.name
}

resource "google_service_networking_connection" "private_vpc" {
  network = var.private_network.name
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.sql.name,
  ]
}