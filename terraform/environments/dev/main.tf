terraform {
  backend "gcs" {
    bucket = "devops-pro-gcp-terraform-2023" # Replace with the name of your GCS bucket
    prefix = "terraform/state"
  }
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "google" {
  project = "gcp-devops-pro-405617"
}

data "google_client_config" "default" {}

resource "google_compute_address" "ip_address" {
  name = "external-ip"
  region = var.region
}

module "instance_template" {
  source          = "terraform-google-modules/vm/google//modules/instance_template"
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  stack_type      = "IPV4_ONLY"
  name_prefix     = "simple"
  access_config   = [local.access_config]
  region          = var.region  # Explicitly define the region if necessary
}


module "vpc_module" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "gcp-certs-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "europe-west2"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "europe-west2"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}
