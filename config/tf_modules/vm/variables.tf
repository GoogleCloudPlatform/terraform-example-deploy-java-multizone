variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "The region chosen to be used."
  type        = string
}

variable "zones" {
  description = "A list of zones that mig can be placed in. The list depends on the region chosen."
  type        = list(string)
}

variable "private_network" {
  type = any
}

variable "xwiki_vm_tag" {
  type = string
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

variable "xwiki_lb_port_name" {
  type = string
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
    image_name    = string
    image_project = string
  })
}