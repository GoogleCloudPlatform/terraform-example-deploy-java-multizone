variable "project_id" {
  description = "The GCP project id"
  type        = string
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "repository_name" {
  type    = string
  default = "xwiki-gce"
}