resource "digitalocean_droplet" "bastion" {
  image    = var.image
  name     = "${var.cluster_name}-bastion"
  region   = var.region
  size     = var.bastion_size
  ssh_keys = concat(var.ssh_keys, [digitalocean_ssh_key.terraform_cloud.fingerprint])
  vpc_uuid = digitalocean_vpc.cluster_vpc.id
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