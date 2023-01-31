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

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}