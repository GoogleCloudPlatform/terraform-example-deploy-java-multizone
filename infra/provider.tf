terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.52"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.21"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.location["region"]
}