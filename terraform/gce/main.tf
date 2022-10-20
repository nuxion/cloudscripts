provider "google" {
  region      = "${var.region}"
  project     = "${var.project_id}"
}

module "sandbox" {
  source = "./modules/sandbox"
  instances = 1
  region_zone = "${var.region_zone}"
  image = "debian-11-bullseye-v20220406"
  boot_disk_size = 10
  operator_user = "${var.operator_user}"
}

output "inventory_sandbox" {
  value = module.sandbox.inventory[*]
}

