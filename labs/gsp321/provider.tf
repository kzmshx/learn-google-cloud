provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.griffin_dev.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.griffin_dev.master_auth[0].cluster_ca_certificate)
}
