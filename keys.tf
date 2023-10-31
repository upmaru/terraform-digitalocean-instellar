resource "tls_private_key" "terraform_cloud" {
  algorithm = "ED25519"
}

resource "tls_private_key" "bastion_key" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "terraform_cloud" {
  name       = "${var.identifier}-terraform-cloud"
  public_key = tls_private_key.terraform_cloud.public_key_openssh
}

resource "digitalocean_ssh_key" "bastion" {
  name       = "${var.identifier}-bastion"
  public_key = tls_private_key.bastion_key.public_key_openssh
}