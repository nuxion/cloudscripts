terraform {
required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

resource "google_compute_instance" "sandbox" {
  count = var.instances
  name         = "sandbox-${count.index}"
  machine_type = "e2-micro"
  zone         = var.region_zone
  tags         = ["sandbox"]

  boot_disk {
    initialize_params {
      image = var.image
      size =  var.boot_disk_size
    }
  }

  network_interface {
    network = google_compute_network.sandbox_net.self_link

    access_config {
      # Ephemeral
    }
  }
}

resource "google_compute_network" "sandbox_net" {
  name                    = "sandbox-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "sandbox_ext_firewall" {
  name    = "sandbox-ext-firewall"
  network = google_compute_network.sandbox_net.name

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

resource "google_compute_firewall" "sandbox_int_firewall" {
  name    = "sandbox-int-firewall"
  network = google_compute_network.sandbox_net.name

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

output "sandbox_net_id"{
 value = google_compute_network.sandbox_net.id
}
output "inventory" {
  value = [for s in google_compute_instance.sandbox[*] : {
    # the Ansible groups to which we will assign the server
    "groups"           : "sandbox",
    "name"             : "${s.name}",
    "ipv4"               : "${s.network_interface.0.network_ip}",
    "ansible_ssh_user" : "${var.operator_user}",
    "tags": "${s.tags}"
  } ]
}
