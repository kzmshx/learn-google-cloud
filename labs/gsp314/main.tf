locals {
  subnets = [
    {
      subnet_name   = var.subnet_1.name
      subnet_region = var.subnet_1.region
      subnet_ip     = "10.10.10.0/24"
      stack_type    = "IPV4_ONLY"
    },
    {
      subnet_name   = var.subnet_2.name
      subnet_region = var.subnet_2.region
      subnet_ip     = "10.10.20.0/24"
      stack_type    = "IPV4_ONLY"
    }
  ]

  ingress_rules = [
    {
      name          = var.fw_name_ssh
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      allow         = [{ protocol = "tcp", ports = ["22"] }]
    },
    {
      name          = var.fw_name_rdp
      priority      = 65535
      source_ranges = ["0.0.0.0/24"]
      allow         = [{ protocol = "tcp", ports = ["3389"] }]
    },
    {
      name          = var.fw_name_icmp
      priority      = 1000
      source_ranges = [for subnet in local.subnets : subnet.subnet_ip]
      allow         = [{ protocol = "icmp" }]
    }
  ]
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.0.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "REGIONAL"

  subnets = local.subnets

  ingress_rules = local.ingress_rules
}

resource "google_compute_instance" "us-test-01" {
  name         = "us-test-01"
  machine_type = "e2-micro"
  zone         = var.instance_1.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_1.name
  }
}

resource "google_compute_instance" "us-test-02" {
  name         = "us-test-02"
  machine_type = "e2-micro"
  zone         = var.instance_2.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_2.name
  }
}
