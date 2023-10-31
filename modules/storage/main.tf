resource "digitalocean_spaces_bucket" "this" {
  name   = var.bucket_name
  region = var.region
}
