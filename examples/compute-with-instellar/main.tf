variable "do_token" {}

locals {
  cluster_name  = "orion"
  provider_name = "digitalocean"
}

module "compute" {
  source = "../.."

  cluster_name = local.cluster_name
  vpc_ip_range = "10.0.2.0/24"
  node_size    = "s-2vcpu-4gb-amd"
  cluster_topology = [
    { id = 1, name = "rigel", size = "s-2vcpu-4gb-amd" },
  ]
  storage_size = 50
  ssh_keys = [
    "97:2f:5d:0d:4c:8d:13:8a:8f:4b:b8:74:c6:59:06:b7",
    "52:0d:1a:16:5e:64:22:28:1c:ec:3a:72:ce:2f:77:ba"
  ]
}

variable "instellar_auth_token" {}

module "instellar" {
  source  = "upmaru/bootstrap/instellar"
  version = "~> 0.3"

  host            = "https://staging-web.instellar.app"
  auth_token      = var.instellar_auth_token
  cluster_name    = local.cluster_name
  region          = module.compute.region
  provider_name   = local.provider_name
  cluster_address = module.compute.cluster_address
  password_token  = module.compute.trust_token

  uplink_channel = "develop"

  bootstrap_node = module.compute.bootstrap_node
  nodes          = module.compute.nodes
}