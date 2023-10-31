resource "digitalocean_droplet" "bastion" {
  image    = var.image
  name     = "${var.identifier}-bastion"
  region   = var.region
  size     = var.bastion_size
  ssh_keys = concat(var.ssh_keys, [digitalocean_ssh_key.terraform_cloud.fingerprint])
  vpc_uuid = var.vpc_id
  tags     = [digitalocean_tag.db_access.id, digitalocean_tag.instellar_bastion.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = tls_private_key.terraform_cloud.private_key_openssh
  }

  provisioner "file" {
    content     = tls_private_key.bastion_key.private_key_openssh
    destination = "/root/.ssh/id_ed25519"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /root/.ssh/id_ed25519"
    ]
  }
}

# tfsec:ignore:digitalocean-compute-no-public-egress
resource "digitalocean_firewall" "bastion_firewall" {
  name = "${var.identifier}-instellar-bastion"

  droplet_ids = digitalocean_droplet.bastion[*].id

  # SSH from any where
  # tfsec:ignore:digitalocean-compute-no-public-ingress[port_range=22]
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