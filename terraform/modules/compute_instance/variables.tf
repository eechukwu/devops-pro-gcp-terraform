variable "instance_name" {
  description = "The name of the compute instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type of the compute instance"
  type        = string
  default     = "e2-micro"
}

variable "zone" {
  description = "The zone to host the compute instance in"
  type        = string
  default     = "us-central1-a"
}
