resource "google_artifact_registry_repository" "example_docker_repo" {
  repository_id = "example-docker-repo"
  format        = "DOCKER"
  location      = var.region
}
