provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "this" {
  image   = var.image
  name    = "${var.project_name}-0${count.index}"
  region  = var.region
  size    = var.size
}