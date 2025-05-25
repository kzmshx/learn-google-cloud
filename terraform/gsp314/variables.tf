variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
  default     = "taw-custom-network"
}

variable "subnet_1" {
  type        = object({ name = string, region = string })
  description = "The configuration for subnet 1"
}

variable "subnet_2" {
  type        = object({ name = string, region = string })
  description = "The configuration for subnet 2"
}

variable "fw_name_ssh" {
  type        = string
  description = "The name of the firewall rule for SSH"
}

variable "fw_name_rdp" {
  type        = string
  description = "The name of the firewall rule for RDP"
}

variable "fw_name_icmp" {
  type        = string
  description = "The name of the firewall rule for ICMP"
}

variable "instance_1" {
  type        = object({ zone = string })
  description = "The configuration for instance 1"
}

variable "instance_2" {
  type        = object({ zone = string })
  description = "The configuration for instance 2"
}
