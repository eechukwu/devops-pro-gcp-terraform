variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
  default     = "gcp-devops-pro-405617"
}

variable "subnetwork" {
  description = "The name of the subnetwork create this instance in."
  default     = "default"
}


variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west2"
}

variable "service_account" {
  default = null
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
}
