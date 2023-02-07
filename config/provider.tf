terraform {
  required_providers {
    google = {
    }
    random = {
      source = "hashicorp/random"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}