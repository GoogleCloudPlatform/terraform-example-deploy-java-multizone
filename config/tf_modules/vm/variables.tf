variable "project_id" {
  description = "GCP project ID. e.g.: test-367504"
  type        = string
}

variable "region" {
  description = "The region chosen to be used. e.q. us-west1"
  type        = string
}

variable "zones" {
  description = "Zones depend on the chosen region. e.q.: [us-west1-a, us-west1-b]"
  type        = list(string)
}

variable "service_account" {
  description = "Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles."
  type = object({
    email  = string
    scopes = set(string)
  })
}

variable "startup_script" {
  description = "The startup script to run when instances start up"
  type        = any
  default     = ""
}

variable "jgroup_bucket_info" {
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "xwiki_img_info" {
  description = "Xwiki app image information."
  type = object({
    image_name = string
    image_project = string
  })
}