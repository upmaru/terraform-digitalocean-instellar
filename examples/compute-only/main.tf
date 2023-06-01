variable "do_token" {}

module "instellar" {
  source = "../.."

  do_token     = var.do_token
  cluster_name = var.cluster_name
  vpc_ip_range = "10.0.2.0/24"
  cluster_topology = [
    { id = 1, name = "apple", size = var.node_size },
    { id = 2, name = "watermelon", size = var.node_size }
  ]
  node_size    = var.node_size
  storage_size = 50
  ssh_keys = [
    "97:2f:5d:0d:4c:8d:13:8a:8f:4b:b8:74:c6:59:06:b7",
    "52:0d:1a:16:5e:64:22:28:1c:ec:3a:72:ce:2f:77:ba"
  ]
}

output "cluster_address" {
  value = module.instellar.cluster_address
}

output "trust_token" {
  value = module.instellar.trust_token
}