output "instance1" {
  description = "main compute instance main 1"
  value       = google_compute_instance.xwiki_01t
}

output "instance2" {
  description = "main compute instance main 2"
  value       = google_compute_instance.xwiki_02t
}

output "template" {
  description = "Self-link of instance template"
  value       = module.google_compute_instance_template.self_link
}