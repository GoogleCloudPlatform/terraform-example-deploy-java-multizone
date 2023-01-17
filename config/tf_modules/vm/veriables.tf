variable "region" {
  description = "The region will be created the vm in, ex: asia-east1, us-west1"
  type        = string
}

variable "zone_code1" {
  description = "The zone-code is used to instance 01, it depends on the region. ex: a"
  type        = string
  default     = "a"
}

variable "zone_code2" {
  description = "The zone-code is used to instance 02, it depends on the region. ex: b"
  type        = string
  default     = "b"
}

variable "project_id" {
  description = "The project ID will be created the vm in. ex: datadogtest-367504"
  type        = string
}
variable "internal_ips" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
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
  description = "User startup script to run when instances spin up"
  type        = any
  default     = ""
}