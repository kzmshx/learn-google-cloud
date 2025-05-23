resource "google_storage_bucket" "tf-state-bucket" {
  name                        = var.bucket_name
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
}
