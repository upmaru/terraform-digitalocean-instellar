resource "digitalocean_vpc" "this" {
  name        = "${var.identifier}-opsmaru-vpc"
  description = "VPC used for https://opsmaru.com nodes"
  region      = var.region
  ip_range    = var.vpc_ip_range
}