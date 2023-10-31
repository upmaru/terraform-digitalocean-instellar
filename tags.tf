resource "digitalocean_tag" "db_access" {
  name = "${var.identifier}-db-access"
}

resource "digitalocean_tag" "instellar_node" {
  name = "${var.identifier}-node"
}

resource "digitalocean_tag" "instellar_bastion" {
  name = "${var.identifier}-bastion"
}