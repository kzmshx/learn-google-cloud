terraform {
  required_version = "~> 1.12.0"

  required_providers {
    google = {
      version = "~> 6.36.0"
    }
    kubernetes = {
      version = "~> 2.37.1"
    }
  }
}
