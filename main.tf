provider "digitalocean" {
  token = var.do_token
}

resource "tls_private_key" "terraform_cloud" {
  algorithm = "ED25519"
}

resource "tls_private_key" "bastion_key" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "terraform_cloud" {
  name       = "${var.cluster_name}-terraform-cloud"
  public_key = tls_private_key.terraform_cloud.public_key_openssh
}

resource "digitalocean_ssh_key" "bastion" {
  name       = "${var.cluster_name}-bastion"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "digitalocean_tag" "db_access" {
  name = "${var.cluster_name}-db-access"
}

resource "digitalocean_tag" "instellar_node" {
  name = "${var.cluster_name}-node"
}

resource "digitalocean_tag" "instellar_bastion" {
  name = "${var.cluster_name}-bastion"
}

resource "digitalocean_vpc" "cluster_vpc" {
  name        = "${var.cluster_name}-instellar-vpc"
  description = "VPC used for https://instellar.app nodes"
  region      = var.region
  ip_range    = var.vpc_ip_range
}

resource "digitalocean_droplet" "bastion" {
  image    = var.image
  name     = "${var.cluster_name}-bastion"
  region   = var.region
  size     = var.bastion_size
  ssh_keys = concat(var.ssh_keys, [digitalocean_ssh_key.terraform_cloud.fingerprint])
  vpc_uuid = digitalocean_vpc.cluster_vpc.id
  tags     = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_bastion.id]
  
  provisioner "file" {
    content = tls_private_key.bastion_key.private_key_openssh
    destination = "/root/.ssh/ed_id25519"
    
    connection {
      type = "ssh"
      user = "root"
      host = self.public_ip
      private_key = tls_private_key.terraform_cloud.private_key_openssh
    }
  }
}

resource "digitalocean_droplet" "nodes" {
  count    = var.cluster_size
  image    = var.image
  name     = "${var.cluster_name}-node.0${count.index + 1}"
  region   = var.region
  size     = var.node_size
  ssh_keys = [digitalocean_ssh_key.bastion.fingerprint]
  vpc_uuid = digitalocean_vpc.cluster_vpc.id
  tags     = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_node.id]
}

resource "digitalocean_firewall" "nodes_firewall" {
  name = "${var.cluster_name}-instellar-nodes"

  tags = [digitalocean_tag.instellar_node.id]

  # SSH is only open to bastion node
  inbound_rule {
    protocol           = "tcp"
    port_range         = "22"
    source_droplet_ids = digitalocean_droplet.bastion[*].id
  }

  # Enable instellar to communicate with the nodes
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Enable full cross-node communication
  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_tags = [digitalocean_tag.instellar_node.id]
  }

  inbound_rule {
    protocol    = "udp"
    port_range  = "1-65535"
    source_tags = [digitalocean_tag.instellar_node.id]
  }

  # Enable all outbound traffic
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "bastion_firewall" {
  name = "${var.cluster_name}-instellar-bastion"

  droplet_ids = digitalocean_droplet.bastion[*].id

  # SSH from any where
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Enable all outbound traffic
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_project" "project" {
  name        = var.cluster_name
  environment = var.environment
  resources = concat(
    digitalocean_droplet.nodes[*].urn,
    digitalocean_droplet.bastion[*].urn
  )
}