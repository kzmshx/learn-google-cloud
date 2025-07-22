# --------------------------------
# Terraform configuration
# --------------------------------
terraform {
  required_version = "~> 1.12.0"

  required_providers {
    google = {
      version = "~> 6.36.0"
    }
  }
}

# --------------------------------
# Provider configuration
# --------------------------------
provider "google" {
  project = var.project_id
}

# --------------------------------
# Variables
# --------------------------------
variable "project_id" {
  type        = string
  description = "The ID of the project"
}
variable "region" {
  type        = string
  description = "The default region for the project"
}
variable "zone" {
  type        = string
  description = "The default zone for the project"
}

# --------------------------------
# Resources
# --------------------------------


# --------------------------------
# Outputs
# --------------------------------
output "project_id" {
  value = var.project_id
}
