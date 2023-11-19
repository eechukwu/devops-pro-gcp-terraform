module "compute_instance" {
  source       = "../../modules/compute_instance"
  instance_name = "test-instance"
  machine_type = "e2-micro"  // Or any other type
  zone         = "us-central1-a" // Or any other zone
}
