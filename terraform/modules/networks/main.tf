# Define your provider (GCP)
provider "google" {
  project = "gcp-devops-pro-405617"
  region  = "us-central1"  # Change to your desired region
}

# Create a VPC network
resource "google_compute_network" "my_network" {
  name = "my-vpc-network-devops"
}

# Create a subnet within the VPC network
resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnet"
  region        = "us-central1"  # Change to the same region as your VPC
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.0.0/24"  # Specify your desired IP range
}


