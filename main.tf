locals {
  user = "root"
  topology = {
    for index, node in var.cluster_topology :
    node.name => node
  }
}

resource "ssh_resource" "trust_token" {
  host         = digitalocean_droplet.bootstrap_node.ipv4_address_private
  bastion_host = digitalocean_droplet.bastion.ipv4_address

  user         = local.user
  bastion_user = local.user

  private_key         = tls_private_key.bastion_key.private_key_openssh
  bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh

  commands = [
    "lxc config trust add --name instellar | sed '1d; /^$/d'"
  ]
}

resource "ssh_resource" "cluster_join_token" {
  for_each = local.topology

  host         = digitalocean_droplet.bootstrap_node.ipv4_address_private
  bastion_host = digitalocean_droplet.bastion.ipv4_address

  user         = local.user
  bastion_user = local.user

  private_key         = tls_private_key.bastion_key.private_key_openssh
  bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh

  commands = [
    "lxc cluster add ${var.identifier}-node-${each.key} | sed '1d; /^$/d'"
  ]
}

resource "digitalocean_droplet" "bootstrap_node" {
  image     = var.image
  name      = "${var.identifier}-bootstrap-node"
  region    = var.region
  size      = var.node_size
  ssh_keys  = [digitalocean_ssh_key.bastion.fingerprint]
  vpc_uuid  = var.vpc_id
  tags      = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_node.id]
  user_data = file("${path.module}/cloud-init.yml")

  connection {
    type                = "ssh"
    user                = local.user
    host                = self.ipv4_address_private
    private_key         = tls_private_key.bastion_key.private_key_openssh
    bastion_user        = local.user
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
      "cloud-init status --wait",
      "lxd init --preseed < /tmp/lxd-init.yml"
    ]
  }
}

resource "digitalocean_droplet" "nodes" {
  for_each  = local.topology
  image     = var.image
  name      = "${var.identifier}-node-${each.key}"
  region    = var.region
  size      = var.node_size
  ssh_keys  = [digitalocean_ssh_key.bastion.fingerprint]
  vpc_uuid  = var.vpc_id
  tags      = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_node.id]
  user_data = file("${path.module}/cloud-init.yml")

  connection {
    type                = "ssh"
    user                = local.user
    host                = self.ipv4_address_private
    private_key         = tls_private_key.bastion_key.private_key_openssh
    bastion_user        = local.user
    bastion_host        = digitalocean_droplet.bastion.ipv4_address
    bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/lxd-join.yml.tpl", {
      ip_address   = self.ipv4_address_private
      join_token   = ssh_resource.cluster_join_token[each.key].result
      storage_size = var.storage_size
    })

    destination = "/tmp/lxd-join.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "lxd init --preseed < /tmp/lxd-join.yml",
    ]
  }
}

# tfsec:ignore:digitalocean-compute-no-public-egress
resource "digitalocean_firewall" "nodes_firewall" {
  name = "${var.identifier}-instellar-nodes"

  tags = [digitalocean_tag.instellar_node.id]

  # SSH is only open to bastion node
  # tfsec:ignore:digitalocean-compute-no-public-ingress[port_range=22]
  inbound_rule {
    protocol           = "tcp"
    port_range         = "22"
    source_droplet_ids = digitalocean_droplet.bastion[*].id
  }

  # Enable instellar to communicate with the nodes
  # tfsec:ignore:digitalocean-compute-no-public-ingress[port_range=8443]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # tfsec:ignore:digitalocean-compute-no-public-ingress[port_range=443]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # tfsec:ignore:digitalocean-compute-no-public-ingress[port_range=80]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # tfsec:ignore:digitalocean-compute-no-public-ingress[port_range=49152]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "49152"
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

resource "digitalocean_project_resources" "this" {
  project     = var.project_id
  resources = concat(
    [for o in digitalocean_droplet.nodes : o.urn],
    digitalocean_droplet.bootstrap_node[*].urn,
    digitalocean_droplet.bastion[*].urn
  )
}

resource "ssh_resource" "node_detail" {
  for_each = local.topology

  triggers = {
    always_run = "${timestamp()}"
  }

  host         = digitalocean_droplet.bootstrap_node.ipv4_address_private
  bastion_host = digitalocean_droplet.bastion.ipv4_address

  user         = local.user
  bastion_user = local.user

  private_key         = tls_private_key.bastion_key.private_key_openssh
  bastion_private_key = tls_private_key.terraform_cloud.private_key_openssh

  commands = [
    "lxc cluster show ${digitalocean_droplet.nodes[each.key].name}"
  ]
}

resource "terraform_data" "reboot" {
  for_each = local.topology

  input = {
    user                        = local.user
    node_name                   = digitalocean_droplet.nodes[each.key].name
    bastion_private_key         = tls_private_key.bastion_key.private_key_openssh
    bastion_public_ip           = digitalocean_droplet.bastion.ipv4_address
    node_private_ip             = digitalocean_droplet.nodes[each.key].ipv4_address_private
    terraform_cloud_private_key = tls_private_key.terraform_cloud.private_key_openssh
    commands = contains(yamldecode(ssh_resource.node_detail[each.key].result).roles, "database-leader") ? ["echo Node is database-leader restarting later", "sudo shutdown -r +1"] : [
      "sudo reboot"
    ]
  }

  connection {
    type                = "ssh"
    user                = self.input.user
    host                = self.input.node_private_ip
    private_key         = self.input.bastion_private_key
    bastion_user        = self.input.user
    bastion_host        = self.input.bastion_public_ip
    bastion_private_key = self.input.terraform_cloud_private_key
    timeout             = "10s"
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline     = self.input.commands
  }
}

resource "terraform_data" "removal" {
  for_each = local.topology

  input = {
    user                        = local.user
    node_name                   = digitalocean_droplet.nodes[each.key].name
    bastion_private_key         = tls_private_key.bastion_key.private_key_openssh
    bastion_public_ip           = digitalocean_droplet.bastion.ipv4_address
    bootstrap_node_private_ip   = digitalocean_droplet.bootstrap_node.ipv4_address_private
    terraform_cloud_private_key = tls_private_key.terraform_cloud.private_key_openssh
    commands = contains(yamldecode(ssh_resource.node_detail[each.key].result).roles, "database-leader") ? ["echo ${var.protect_leader ? "Node is database-leader cannot destroy" : "Tearing it all down"}", "exit ${var.protect_leader ? 1 : 0}"] : [
      "lxc cluster remove --force --yes ${digitalocean_droplet.nodes[each.key].name}"
    ]
  }

  depends_on = [
    digitalocean_droplet.bastion,
    digitalocean_droplet.bootstrap_node,
    var.vpc_id,
    digitalocean_firewall.bastion_firewall,
    digitalocean_firewall.nodes_firewall
  ]

  connection {
    type                = "ssh"
    user                = self.input.user
    host                = self.input.bootstrap_node_private_ip
    private_key         = self.input.bastion_private_key
    bastion_user        = self.input.user
    bastion_host        = self.input.bastion_public_ip
    bastion_private_key = self.input.terraform_cloud_private_key
    timeout             = "10s"
  }

  provisioner "remote-exec" {
    when   = destroy
    inline = self.input.commands
  }
}