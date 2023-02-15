variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources. ex: datadogtest-367504"
  type        = string
}

variable "region" {
  description = "The region of the Cloud SQL resource. ex: asia-east1, us-west1"
  type        = string
}

variable "zones" {
  description = "Zones are used for DB location_preference, they depend on the region. E.g.: [us-west1-a, us-west1-b]"
  type        = list(string)
}

variable "xwiki_sql_user_password" {
  description = "Default password for user xwiki"
  type        = string
}

variable "availability_type" {
  description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL)."
  type        = string
  validation {
    condition     = contains(["REGIONAL", "ZONAL"], var.availability_type)
    error_message = "Allowed values for type are \"REGIONAL\", \"ZONAL\"."
  }
}