variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources."
  type        = string
}

variable "region" {
  description = "The region of the Cloud SQL resource."
  type        = string
}

variable "zones" {
  description = "A list of zones that DB location_preference can be placed in. The list depends on the region chosen."
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