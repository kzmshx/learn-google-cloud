/**
 * mynetwork
 */

resource "google_compute_network" "mynetwork" {
  name = "mynetwork"
}

import {
  to = google_compute_network.mynetwork
  id = "${var.project_id}/mynetwork"
}

resource "google_compute_instance" "mynet_vm_1" {
  name         = "mynet-vm-1"
  machine_type = "e2-medium"
  zone         = var.zone_1

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.mynetwork.id
    access_config {}
  }
}

import {
  to = google_compute_instance.mynet_vm_1
  id = "${var.project_id}/${var.zone_1}/mynet-vm-1"
}

resource "google_compute_instance" "mynet_vm_2" {
  name         = "mynet-vm-2"
  machine_type = "e2-medium"
  zone         = var.zone_2

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.mynetwork.id
    access_config {}
  }
}

import {
  to = google_compute_instance.mynet_vm_2
  id = "${var.project_id}/${var.zone_2}/mynet-vm-2"
}

/**
 * managementnet
 */

resource "google_compute_network" "managementnet" {
  name                    = "managementnet"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "managementsubnet_1" {
  name          = "managementsubnet-1"
  network       = google_compute_network.managementnet.id
  region        = var.region_1
  ip_cidr_range = "10.130.0.0/20"
}

resource "google_compute_firewall" "managementnet_allow_icmp_ssh_rdp" {
  name          = "managementnet-allow-icmp-ssh-rdp"
  network       = google_compute_network.managementnet.id
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

/**
 * managementnet > vm
 */

resource "google_compute_instance" "managementnet_vm_1" {
  name         = "managementnet-vm-1"
  machine_type = "e2-micro"
  zone         = var.zone_1

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.managementnet.id
    subnetwork = google_compute_subnetwork.managementsubnet_1.id
    access_config {}
  }
}

/**
 * privatenet
 */

resource "google_compute_network" "privatenet" {
  name                    = "privatenet"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "privatesubnet_1" {
  name          = "privatesubnet-1"
  network       = google_compute_network.privatenet.id
  region        = var.region_1
  ip_cidr_range = "172.16.0.0/24"
}

resource "google_compute_subnetwork" "privatesubnet_2" {
  name          = "privatesubnet-2"
  network       = google_compute_network.privatenet.id
  region        = var.region_2
  ip_cidr_range = "172.20.0.0/20"
}

resource "google_compute_firewall" "privatenet_allow_icmp_ssh_rdp" {
  name          = "privatenet-allow-icmp-ssh-rdp"
  network       = google_compute_network.privatenet.id
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

/**
 * privatenet > vm
 */

resource "google_compute_instance" "privatenet_vm_1" {
  name         = "privatenet-vm-1"
  machine_type = "e2-micro"
  zone         = var.zone_1

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.privatenet.id
    subnetwork = google_compute_subnetwork.privatesubnet_1.id
    access_config {}
  }
}

/**
 * vm-appliance
 */

resource "google_compute_instance" "vm_appliance" {
  name         = "vm-appliance"
  machine_type = "e2-standard-4"
  zone         = var.zone_1

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.mynetwork.id
  }

  network_interface {
    network    = google_compute_network.managementnet.id
    subnetwork = google_compute_subnetwork.managementsubnet_1.id
  }

  network_interface {
    network    = google_compute_network.privatenet.id
    subnetwork = google_compute_subnetwork.privatesubnet_1.id
  }
}
