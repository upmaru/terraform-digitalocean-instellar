variable "identifier" {}

variable "do_region" {}
variable "do_token" {}

variable "do_access_key" {}
variable "do_secret_key" {}

provider "digitalocean" {
  token = var.do_token

  spaces_access_id  = var.do_access_key
  spaces_secret_key = var.do_secret_key
}

locals {
  provider_name = "digitalocean"
}

module "bucket" {
  source = "../../modules/storage"

  bucket_name = var.identifier
  region      = var.do_region
}


module "networking_primary" {
  source = "../../modules/network"

  identifier   = var.identifier
  region       = var.do_region
  vpc_ip_range = "10.0.1.0/24"
}

module "compute_primary" {
  source = "../.."

  identifier = "${var.identifier}-a"

  vpc_id       = module.networking_primary.vpc_id
  vpc_ip_range = module.networking_primary.vpc_ip_range
  storage_size = 50
  cluster_topology = [
    { id = 1, name = "01", size = "s-2vcpu-4gb-amd" },
    { id = 2, name = "02", size = "s-2vcpu-4gb-amd" }
  ]
  ssh_keys = []
}
