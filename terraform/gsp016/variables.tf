variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "region" {
  type        = string
  description = "The region of the project"
}

variable "zone" {
  type        = string
  description = "The zone of the project"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
}

variable "subnets" {
  type = list(object({
    region = string
    ip     = string
  }))
}
