resource "digitalocean_tag" "db_access" {
  name = "${var.cluster_name}-db-access"
}

resource "digitalocean_tag" "instellar_node" {
  name = "${var.cluster_name}-node"
}

resource "digitalocean_tag" "instellar_bastion" {
  name = "${var.cluster_name}-bastion"
}