# Output the subnet self-link
output "subnet_self_link" {
  value = google_compute_subnetwork.my_subnet.self_link
}