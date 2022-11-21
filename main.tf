provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_vpc" "nodes_vpc" {
  name        = "${var.cluster_name}-instellar-vpc"
  description = "VPC used for instellar.app nodes"
  region      = var.region
  ip_range    = var.vpc_ip_range
}

resource "digitalocean_droplet" "bastion" {
  image    = var.image
  name     = "${var.cluster_name}-bastion"
  region   = var.region
  size     = var.bastion_size
  ssh_keys = var.ssh_keys
}

resource "digitalocean_droplet" "nodes" {
  count    = var.cluster_size
  image    = var.image
  name     = "${var.cluster_name}.0${count.index + 1}"
  region   = var.region
  size     = var.node_size
  vpc_uuid = digitalocean_vpc.nodes_vpc.id
}

resource "digitalocean_firewall" "nodes_firewall" {
  name = "${var.cluster_name}-instellar-nodes"

  droplet_ids = digitalocean_droplet.nodes[*].id

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

  # Enable all outbound traffic
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
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