module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 11.0.0"

  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name   = "subnet-${var.region}"
      subnet_ip     = "10.0.0.0/16"
      subnet_region = var.region
    },
    {
      subnet_name   = "subnet-${var.subnet_region_1}"
      subnet_ip     = "10.1.0.0/16"
      subnet_region = var.subnet_region_1
    },
    {
      subnet_name   = "subnet-${var.subnet_region_2}"
      subnet_ip     = "10.2.0.0/16"
      subnet_region = var.subnet_region_2
    }
  ]

  ingress_rules = [
    {
      name          = "nw101-allow-http"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["http"]
      allow         = [{ protocol = "tcp", ports = ["80"] }]
    },
    {
      name          = "nw101-allow-icmp"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["icmp"]
      allow         = [{ protocol = "icmp" }]
    },
    {
      name          = "nw101-allow-internal"
      source_ranges = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
      allow = [
        { protocol = "tcp", ports = ["0-65535"] },
        { protocol = "udp", ports = ["0-65535"] },
        { protocol = "icmp" }
      ]
    },
    {
      name          = "nw101-allow-ssh"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["ssh"]
      allow         = [{ protocol = "tcp", ports = ["22"] }]
    },
    {
      name          = "nw101-allow-rdp"
      source_ranges = ["0.0.0.0/0"]
      allow         = [{ protocol = "tcp", ports = ["3389"] }]
    }
  ]
}
