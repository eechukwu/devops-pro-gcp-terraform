terraform {
  backend "gcs" {
    bucket = "devops-pro-gcp-terraform-2023" # Replace with the name of your GCS bucket
    prefix = "terraform/state"
  }
}

resource "google_compute_address" "ip_address" {
  name = "external-ip"
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ip_address.address
    network_tier = "PREMIUM"
  }
}

module "instance_template" {
  source          = "terraform-google-modules/vm/google"
  version         = "v10.1.1"  # Specify the version you want to use
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  stack_type      = "IPV4_ONLY"
  name_prefix     = "simple"
  access_config   = [local.access_config]
}

provider "google" {
  project = "gcp-devops-pro-405617"
  region  = "europe-west2" # Replace with your GCP region
  # Optionally specify the zone
}

