resource "google_storage_bucket" "cloud_sql_source" {
  name                        = "${var.project_id}-cloud-sql-source"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "start_station_data_csv" {
  name   = "start_station_data.csv"
  source = "assets/start_station_data.csv"
  bucket = google_storage_bucket.cloud_sql_source.name
}

resource "google_storage_bucket_object" "end_station_data_csv" {
  name   = "end_station_data.csv"
  source = "assets/end_station_data.csv"
  bucket = google_storage_bucket.cloud_sql_source.name
}

resource "google_sql_database_instance" "my_demo" {
  name             = "my-demo"
  region           = var.region
  database_version = "MYSQL_8_0"
  settings {
    tier                        = "db-custom-4-16384"
    availability_type           = "ZONAL"
    deletion_protection_enabled = true
  }
}

import {
  to = google_sql_database_instance.my_demo
  id = "my-demo"
}

resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.my_demo.name
}

import {
  to = google_sql_user.root
  id = "${var.project_id}/${google_sql_database_instance.my_demo.name}/${google_sql_database_instance.my_demo.dns_name}/root"
}
