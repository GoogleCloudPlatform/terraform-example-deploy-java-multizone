terraform {
  required_providers {
    google = {
      version = "4.37.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
