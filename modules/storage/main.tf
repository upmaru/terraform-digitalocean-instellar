resource "random_string" "this" {
  length    = 6
  special   = false
  min_lower = 6
}

locals {
  bucket_name = replace(replace(lower(var.bucket_name), "/[^a-z0-9]+/", "-"), "^-|-$", "")
}

resource "digitalocean_spaces_bucket" "this" {
  name   = "${local.bucket_name}-${random_string.this.result}"
  region = var.region

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}
