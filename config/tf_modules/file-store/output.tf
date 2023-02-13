output "file_store_ip" {
  description = "To get file_store_ip, refer to https://github.com/hashicorp/terraform-provider-google/issues/3063"
  value       = google_filestore_instance.xwiki.networks[0].ip_addresses[0]
}