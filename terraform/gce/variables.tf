// https://cloud.google.com/compute/docs/regions-zones
variable "project_id" {
 description = "Google Project ID"
 type = string
}

variable "region" {
  description = "Region"
  type = string
  default = "us-central1"
}

variable "region_zone" {
  description = "Region/Zone"
  type = string
  default = "us-central1-c"
}

variable "operator_user" {
 description = "O.S. User"
 type = string
 default = "op"
}


