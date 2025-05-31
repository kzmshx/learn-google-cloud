data "google_client_config" "current" {}

resource "google_service_account" "cloud_sql_proxy" {
  account_id = "cloud-sql-proxy"
}

import {
  to = google_service_account.cloud_sql_proxy
  id = "projects/${var.project_id}/serviceAccounts/cloud-sql-proxy@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_service_account_key" "cloud_sql_proxy_key" {
  service_account_id = google_service_account.cloud_sql_proxy.name
}

/**
Development VPC

- griffin-dev-vpc
  - griffin-dev-wp (192.168.16.0/20)
    - griffin-dev
      - monitoring
  - griffin-dev-mgmt (192.168.32.0/20)
  - griffin-dev-db
  - firewall
    - allow ssh for bastion instance
*/

resource "google_compute_network" "griffin_dev_vpc" {
  name                    = "griffin-dev-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "griffin_dev_wp" {
  name          = "griffin-dev-wp"
  ip_cidr_range = "192.168.16.0/20"
  region        = var.region
  network       = google_compute_network.griffin_dev_vpc.id
}

resource "google_compute_subnetwork" "griffin_dev_mgmt" {
  name          = "griffin-dev-mgmt"
  ip_cidr_range = "192.168.32.0/20"
  region        = var.region
  network       = google_compute_network.griffin_dev_vpc.id
}

resource "google_compute_firewall" "griffin_dev_allow_ssh" {
  name          = "griffin-dev-allow-ssh"
  network       = google_compute_network.griffin_dev_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "griffin_dev_allow_http" {
  name          = "griffin-dev-allow-http"
  network       = google_compute_network.griffin_dev_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["griffin-dev"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_sql_database_instance" "griffin_dev_db" {
  name             = "griffin-dev-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier                        = "db-f1-micro"
    availability_type           = "ZONAL"
    deletion_protection_enabled = true
  }
}

resource "google_sql_database" "wordpress_dev" {
  name     = "wordpress"
  instance = google_sql_database_instance.griffin_dev_db.name
}

resource "google_sql_user" "wp_user_dev" {
  name     = "wp_user"
  instance = google_sql_database_instance.griffin_dev_db.name
  password = "stormwind_rules"
}

resource "google_service_account" "griffin_dev_sa" {
  account_id   = "griffin-dev-sa"
  display_name = "Griffin Dev Service Account"
}

resource "google_container_cluster" "griffin_dev" {
  name     = "griffin-dev"
  location = var.zone

  initial_node_count = 2
  node_config {
    machine_type    = "e2-standard-4"
    service_account = google_service_account.griffin_dev_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = ["griffin-dev"]
  }

  network    = google_compute_network.griffin_dev_vpc.id
  subnetwork = google_compute_subnetwork.griffin_dev_wp.id
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
  }
  spec {
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    selector = {
      app = "wordpress"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "wordpress" {
  metadata {
    name      = "wordpress-volumeclaim"
    namespace = "default"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "200Gi"
      }
    }
    storage_class_name = "standard"
  }
  depends_on = [google_container_cluster.griffin_dev]
}

resource "kubernetes_secret" "cloudsql_instance_credentials" {
  metadata {
    name      = "cloudsql-instance-credentials"
    namespace = "default"
  }
  data = {
    "key.json" = base64decode(google_service_account_key.cloud_sql_proxy_key.private_key)
  }
  type = "Opaque"
}

resource "kubernetes_secret" "database" {
  metadata {
    name      = "database"
    namespace = "default"
  }
  data = {
    username = base64encode(google_sql_user.wp_user_dev.name)
    password = base64encode(google_sql_user.wp_user_dev.password)
  }
  type = "Opaque"
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
    namespace = "default"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "wordpress"
      }
    }
    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }
      spec {
        container {
          name  = "wordpress"
          image = "wordpress"
          port {
            container_port = 80
            name           = "wordpress"
          }
          env {
            name  = "WORDPRESS_DB_HOST"
            value = "127.0.0.1:3306"
          }
          env {
            name = "WORDPRESS_DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database.metadata[0].name
                key  = "username"
              }
            }
          }
          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database.metadata[0].name
                key  = "password"
              }
            }
          }
          volume_mount {
            name       = "wordpress-persistent-storage"
            mount_path = "/var/www/html"
          }
        }
        container {
          name  = "cloudsql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.33.2"
          command = [
            "/cloud_sql_proxy",
            "-instances=${google_sql_database_instance.griffin_dev_db.connection_name}=tcp:3306",
            "-credential_file=/secrets/cloudsql/key.json"
          ]
          security_context {
            run_as_user                = 2
            allow_privilege_escalation = false
          }
          volume_mount {
            name       = "cloudsql-instance-credentials"
            mount_path = "/secrets/cloudsql"
            read_only  = true
          }
        }
        volume {
          name = "wordpress-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wordpress.metadata[0].name
          }
        }
        volume {
          name = "cloudsql-instance-credentials"
          secret {
            secret_name = kubernetes_secret.cloudsql_instance_credentials.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.database,
    kubernetes_secret.cloudsql_instance_credentials,
    kubernetes_persistent_volume_claim.wordpress
  ]
}

resource "google_monitoring_uptime_check_config" "wordpress" {
  display_name = "wordpress-uptime-check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    port = 80
    path = "/"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = kubernetes_service.wordpress.status[0].load_balancer[0].ingress[0].ip
    }
  }

  depends_on = [kubernetes_service.wordpress]
}


/**
Production VPC

- griffin-prod-vpc
  - griffin-prod-wp (192.168.48.0/20)
  - griffin-prod-mgmt (192.168.64.0/20)
  - firewall
    - allow ssh for bastion instance
*/

resource "google_compute_network" "griffin_prod_vpc" {
  name                    = "griffin-prod-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "griffin_prod_wp" {
  name          = "griffin-prod-wp"
  ip_cidr_range = "192.168.48.0/20"
  region        = var.region
  network       = google_compute_network.griffin_prod_vpc.id
}

resource "google_compute_subnetwork" "griffin_prod_mgmt" {
  name          = "griffin-prod-mgmt"
  ip_cidr_range = "192.168.64.0/20"
  region        = var.region
  network       = google_compute_network.griffin_prod_vpc.id
}

resource "google_compute_firewall" "griffin_prod_allow_ssh" {
  name          = "griffin-prod-allow-ssh"
  network       = google_compute_network.griffin_prod_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

/**
Bastion Instance

- network
  - griffin-dev-vpc
    - griffin-dev-mgmt
  - griffin-prod-vpc
    - griffin-prod-mgmt
- allow ssh
*/

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.griffin_dev_vpc.id
    subnetwork = google_compute_subnetwork.griffin_dev_mgmt.id
    access_config {}
  }

  network_interface {
    network    = google_compute_network.griffin_prod_vpc.id
    subnetwork = google_compute_subnetwork.griffin_prod_mgmt.id
    access_config {}
  }

  tags = ["bastion"]
}

/**
Additional Engineer Access

- editor role
*/

resource "google_project_iam_member" "member_1" {
  project = var.project_id
  role    = "roles/editor"
  member  = "user:${var.member_1_email}"
}
