module "network" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"

  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    for s in var.subnets : {
      subnet_name   = "subnet-${s.region}"
      subnet_ip     = s.ip
      subnet_region = s.region
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
      source_ranges = [for s in var.subnets : s.ip]
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
      name         = "nw101-allow-rdp"
      source_range = ["0.0.0.0/0"]
      allow        = [{ protocol = "tcp", ports = ["3389"] }]
    }
  ]
}
