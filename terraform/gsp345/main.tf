terraform {
  # backend "gcs" {
  #   bucket = "tf-bucket-851190"
  #   prefix = "terraform/state"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"

  project_id   = var.project_id
  network_name = "tf-vpc-417649"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    },
  ]

  ingress_rules = [
    {
      name          = "tf-firewall"
      description   = "Allow HTTP"
      source_ranges = ["0.0.0.0/0"]
      allow         = [{ protocol = "tcp", ports = ["80"] }]
    }
  ]
}

module "instances" {
  source = "./modules/instances"

  instance_1_network_name = module.network.network_name
  instance_1_subnet_name  = module.network.subnets_names[0]
  instance_2_network_name = module.network.network_name
  instance_2_subnet_name  = module.network.subnets_names[1]
}

module "storage" {
  source = "./modules/storage"

  bucket_name = "tf-bucket-851190"
}
