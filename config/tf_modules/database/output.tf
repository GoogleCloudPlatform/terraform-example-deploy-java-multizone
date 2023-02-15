output "db_ip" {
  description = "The IPv4 address assigned for the master instance"
  value       = google_sql_database_instance.xwiki_instance.private_ip_address
}

output "xwiki_user" {
  value = google_sql_user.xwiki_user
}