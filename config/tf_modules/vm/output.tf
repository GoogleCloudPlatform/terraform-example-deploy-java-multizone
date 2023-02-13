output "instance1" {
  description = "Main compute instance 1"
  value       = google_compute_instance.xwiki_01t
}

output "instance2" {
  description = "Main compute instance 2"
  value       = google_compute_instance.xwiki_02t
}

output "xwiki_mig" {
  description = "Xwiki managed instance group"
  value = module.xwiki_mig
}