output "instance1" {
  description = "Compute instance for XWiki"
  value       = google_compute_instance.xwiki_01t
}

output "instance2" {
  description = "Compute instance for XWiki"
  value       = google_compute_instance.xwiki_02t
}

output "xwiki_mig" {
  description = "Xwiki managed instance group"
  value = module.xwiki_mig
}