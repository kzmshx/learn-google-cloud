output "mynet_vm_1_external_ip" {
  value = google_compute_instance.mynet_vm_1.network_interface[0].access_config[0].nat_ip
}

output "mynet_vm_2_external_ip" {
  value = google_compute_instance.mynet_vm_2.network_interface[0].access_config[0].nat_ip
}

output "managementnet_vm_1_external_ip" {
  value = google_compute_instance.managementnet_vm_1.network_interface[0].access_config[0].nat_ip
}

output "managementnet_vm_1_internal_ip" {
  value = google_compute_instance.managementnet_vm_1.network_interface[0].network_ip
}

output "privatenet_vm_1_external_ip" {
  value = google_compute_instance.privatenet_vm_1.network_interface[0].access_config[0].nat_ip
}

output "privatenet_vm_1_internal_ip" {
  value = google_compute_instance.privatenet_vm_1.network_interface[0].network_ip
}
