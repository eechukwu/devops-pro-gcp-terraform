terraform {
  backend "gcs" {
    bucket = "devops-pro-gcp-terraform-2023"  # Replace with the name of your GCS bucket
    prefix = "terraform/state"
  }
}

module "compute_instance" {
  source        = "../../modules/compute_instance"
  instance_name = "test-instance"
  machine_type  = "e2-micro"      // Or any other type
  zone          = "us-central1-a" // Or any other zone
}

provider "google" {
  project = "gcp-devops-pro-405617"
  region  = "us-central1-a"  # Replace with your GCP region
  # Optionally specify the zone
}

