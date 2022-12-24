variable "network" {
  description = "A reference (self link) to the VPC network to host the instance"
  type        = string
}

variable "subnetwork" {
  description = "A reference (self link) to the subnetwork to host the instance in"
  type        = string
}