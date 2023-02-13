variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources. ex: datadogtest-367504"
  type        = string
}

variable "region" {
  description = "he region of the Cloud SQL resource. ex: asia-east1, us-west1"
  type        = string
}

variable "zone_code1" {
  description = "The zone-code1 is used to DB location_preference, it depends on the region. ex: a"
  type        = string
  default     = "a"
}

variable "zone_code2" {
  description = "The zone-code2 is used to DB location_preference, it depends on the region. ex: b"
  type        = string
  default     = "b"
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