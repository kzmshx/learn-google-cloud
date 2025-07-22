data "google_project" "this" {
  project_id = var.project_id
}

module "enabled_apis" {
  source     = "./modules/apis"
  project_id = var.project_id
  apis = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "sourcerepo.googleapis.com",
  ]
}

resource "google_artifact_registry_repository" "my_repository" {
  repository_id = "my-repository"
  format        = "DOCKER"
  location      = var.region
}

resource "google_container_cluster" "hello_cloudbuild" {
  name     = "hello-cloudbuild"
  location = var.region

  initial_node_count = 1
}

/**
 * app リポジトリ
 */

resource "google_sourcerepo_repository" "app" {
  name    = "hello-cloudbuild-app"
  project = var.project_id
}

/**
 * env リポジトリ
 */

resource "google_sourcerepo_repository" "env" {
  name    = "hello-cloudbuild-env"
  project = var.project_id
}

/**
 * Cloud Build
 */

resource "google_sourcerepo_repository_iam_member" "cloudbuild_app_source_reader" {
  repository = google_sourcerepo_repository.app.name
  role       = "roles/source.reader"
  member     = "serviceAccount:${data.google_project.this.number}@cloudbuild.gserviceaccount.com"
  depends_on = [module.enabled_apis]
}

resource "google_sourcerepo_repository_iam_member" "cloudbuild_env_source_writer" {
  repository = google_sourcerepo_repository.env.name
  role       = "roles/source.writer"
  member     = "serviceAccount:${data.google_project.this.number}@cloudbuild.gserviceaccount.com"

  depends_on = [module.enabled_apis]
}

resource "google_project_iam_member" "cloudbuild_container_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${data.google_project.this.number}@cloudbuild.gserviceaccount.com"

  depends_on = [module.enabled_apis]
}

resource "google_cloudbuild_trigger" "app" {
  name    = "hello-cloudbuild"
  project = var.project_id

  # repository_event_config {
  #   repository = google_sourcerepo_repository.app.id
  #   push {
  #     branch = ".*"
  #   }
  # }

  trigger_template {
    project_id  = var.project_id
    repo_name   = google_sourcerepo_repository.app.name
    branch_name = ".*"
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION = var.region
  }

  depends_on = [module.enabled_apis, google_sourcerepo_repository_iam_member.cloudbuild_app_source_reader]
}

resource "google_cloudbuild_trigger" "env" {
  name    = "hello-cloudbuild-deploy"
  project = var.project_id

  # repository_event_config {
  #   repository = google_sourcerepo_repository.env.id
  #   push {
  #     branch = "^candidate$"
  #   }
  # }

  trigger_template {
    project_id  = var.project_id
    repo_name   = google_sourcerepo_repository.env.name
    branch_name = "^candidate$"
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION       = var.region
    _CLUSTER_NAME = google_container_cluster.hello_cloudbuild.name
  }

  depends_on = [module.enabled_apis, google_sourcerepo_repository_iam_member.cloudbuild_env_source_writer]
}
