output "project_id" {
  value = data.google_project.project.project_id
}

output "project_number" {
  value = data.google_project.project.number
}

output "bucket_name" {
  value = google_storage_bucket.infra_state.name
}