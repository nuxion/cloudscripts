provider "google" {
  region      = "${var.region}"
  project     = "${var.project_id}"
  credentials = "${file("${var.credentials_file_path}")}"
}

resource "google_compute_network" "project_net" {
  name                    = "project-network"
  auto_create_subnetworks = "true"
}

module "sandbox" {
  source = "./modules/sandbox"
  instances = 0
  region_zone = "${var.region_zone}"
  image = "debian-11-bullseye-v20220406"
  boot_disk_size = 10
  operator_user = "${var.operator_user}"
}


resource "google_compute_firewall" "project_ext_firewall" {
  name    = "project-ext-firewall"
  network = google_compute_network.project_net.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22", "52112"]
  }
  allow {
    protocol = "udp"
    ports    = ["52112"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "project_int_firewall" {
  name    = "project-int-firewall"
  network = google_compute_network.project_net.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22", "7946", "7373", "52112"]
  }

  allow {
    protocol = "udp"
    ports    = ["7946", "52112"]
  }

  source_tags = ["sandbox"]
}



output "inventory_sandbox" {
  value = module.sandbox.inventory[*]
}

