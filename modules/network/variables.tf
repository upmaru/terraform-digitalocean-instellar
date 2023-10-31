variable "identifier" {
  description = "Name of your network"
  type = string
}

variable "vpc_ip_range" {
  description = "The IP range to use for VPC"
  default     = "10.0.1.0/24"
}

variable "region" {
  description = "Region or availability zone"
  type = string
}