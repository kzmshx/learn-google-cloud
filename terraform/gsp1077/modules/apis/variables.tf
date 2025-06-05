variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "apis" {
  type        = list(string)
  description = "The list of APIs to enable"
}
