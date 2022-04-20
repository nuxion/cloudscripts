variable "instances" {
    description = "How many instances to create"
    type = number
    default = 0
}

variable "region_zone" {
    description = "Region where it will be created"
    type = string

}

variable "image" {
    description = "Image to use for boot disk"
    type = string
}

variable "boot_disk_size" {
    description = "Size in GB for the boot disk"
    type = number
    default = 10
}

variable "operator_user" {
    description = "Operator user"
    type = string
    default = "op"
}