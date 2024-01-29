output "name" {
  value = digitalocean_spaces_bucket.this.name
}

output "host" {
  value = "${digitalocean_spaces_bucket.this.region}.digitaloceanspaces.com"
}