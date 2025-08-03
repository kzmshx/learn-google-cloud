variable "project_id" {
  description = "GCPのプロジェクトID"
  type        = string
}

variable "region" {
  description = "GCPのリージョン"
  type        = string
}

variable "zone" {
  description = "GCPのゾーン"
  type        = string
}

variable "example_bucket_name" {
  description = "バケット名"
  type        = string
}
