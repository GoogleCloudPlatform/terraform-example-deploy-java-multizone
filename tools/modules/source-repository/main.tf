resource "google_sourcerepo_repository" "repo" {
  name = var.repository_name
}

resource "google_service_account" "cloudbuild_service_account" {
  account_id   = "${var.service_account_name}"
  display_name = "${var.service_account_name}"
}

resource "google_project_iam_member" "cloud_build" { // Notice! do not use owner in prod site
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_cloudbuild_trigger" "apply" {
  service_account = google_service_account.cloudbuild_service_account.id
  name            = "${var.repository_name}-apply"
  location        = var.region
  trigger_template {
    branch_name = "^(main|master)$"
    repo_name   = google_sourcerepo_repository.repo.name
  }
  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "destroy" {
  service_account = google_service_account.cloudbuild_service_account.id
  name            = "${var.repository_name}-destroy"
  location        = var.region

  source_to_build {
    uri       = "${google_sourcerepo_repository.repo.url}"
    ref       = "refs/heads/main"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
  }
  filename = "cloudbuild-destroy.yaml"
}