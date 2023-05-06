provider "digitalocean" {
  token = var.do_token
}

resource "ssh_resource" "trust_token" {
  host         = digitalocean_droplet.boostrap_node.ipv4_address_private
  bastion_host = digitalocean_droplet.bastion.ipv4_address

  user         = "root"
  bastion_user = "root"

  private_key         = tls_private_key.bastion_key.private_key_openssh
  bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh

  commands = [
    "lxc config trust add --name instellar | sed '1d; /^$/d'"
  ]
}

resource "ssh_resource" "cluster_join_token" {
  count = var.cluster_size

  host         = digitalocean_droplet.boostrap_node.ipv4_address_private
  bastion_host = digitalocean_droplet.bastion.ipv4_address

  user         = "root"
  bastion_user = "root"

  private_key         = tls_private_key.bastion_key.private_key_openssh
  bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh

  commands = [
    "lxc cluster add ${var.cluster_name}-node-${format("%02d", count.index + 1)} | sed '1d; /^$/d'"
  ]
}

resource "digitalocean_droplet" "boostrap_node" {
  image     = var.image
  name      = "${var.cluster_name}-bootstrap-node"
  region    = var.region
  size      = var.node_size
  ssh_keys  = [digitalocean_ssh_key.bastion.fingerprint]
  vpc_uuid  = digitalocean_vpc.cluster_vpc.id
  tags      = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_node.id]
  user_data = file("cloud-init.yml")

  connection {
    type                = "ssh"
    user                = "root"
    host                = self.ipv4_address_private
    private_key         = tls_private_key.bastion_key.private_key_openssh
    bastion_user        = "root"
    bastion_host        = digitalocean_droplet.bastion.ipv4_address
    bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/lxd-init.yml.tpl", {
      ip_address   = self.ipv4_address_private
      server_name  = self.name
      vpc_ip_range = var.vpc_ip_range
      storage_size = var.storage_size
    })

    destination = "/tmp/lxd-init.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "lxd init --preseed < /tmp/lxd-init.yml"
    ]
  }
}

resource "digitalocean_droplet" "nodes" {
  count     = var.cluster_size
  image     = var.image
  name      = "${var.cluster_name}-node-${format("%02d", count.index + 1)}"
  region    = var.region
  size      = var.node_size
  ssh_keys  = [digitalocean_ssh_key.bastion.fingerprint]
  vpc_uuid  = digitalocean_vpc.cluster_vpc.id
  tags      = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_node.id]
  user_data = file("cloud-init.yml")

  connection {
    type                = "ssh"
    user                = "root"
    host                = self.ipv4_address_private
    private_key         = tls_private_key.bastion_key.private_key_openssh
    bastion_user        = "root"
    bastion_host        = digitalocean_droplet.bastion.ipv4_address
    bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/lxd-join.yml.tpl", {
      ip_address   = self.ipv4_address_private
      join_token   = ssh_resource.cluster_join_token[count.index].result
      storage_size = var.storage_size
    })

    destination = "/tmp/lxd-join.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "lxd init --preseed < /tmp/lxd-join.yml",
      "shutdown -r +1"
    ]
  }
}

resource "digitalocean_project" "project" {
  name        = var.cluster_name
  environment = var.environment
  resources = concat(
    digitalocean_droplet.nodes[*].urn,
    digitalocean_droplet.boostrap_node[*].urn,
    digitalocean_droplet.bastion[*].urn
  )
}