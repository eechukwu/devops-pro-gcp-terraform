terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "devops-pro-gcp-terraform-2023"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "gcp-devops-pro-405617"
  region  = "europe-west2" # Replace with your GCP region
  # Optionally specify the zone
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ip_address.address
    network_tier = "PREMIUM"
  }
   cluster_type = "simple-regional"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}


resource "google_compute_address" "ip_address" {
  name = "external-ip"
}

module "instance_template" {
  source          = "terraform-google-modules/vm/google//modules/instance_template"
  version         = "v9.0.0"  # Specify the version you want to use
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  stack_type      = "IPV4_ONLY"
  name_prefix     = "simple"
  access_config   = [local.access_config]
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = var.project_id # Replace this with your project ID in quotes
  network_name = "gcp-certs-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 29.0"

  project_id                  = var.project_id
  name                        = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                    = true
  region                      = var.region
  network                     = var.network
  subnetwork                  = var.subnetwork
  ip_range_pods               = var.ip_range_pods
  ip_range_services           = var.ip_range_services
  create_service_account      = false
  service_account             = var.compute_engine_service_account
  enable_cost_allocation      = true
  enable_binary_authorization = var.enable_binary_authorization
  gcs_fuse_csi_driver         = true
  deletion_protection         = false
}
