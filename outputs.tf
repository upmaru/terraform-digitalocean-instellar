output "cluster_vpc_id" {
  value = digitalocean_vpc.cluster_vpc.id
}

output "db_access_tag_id" {
  value = digitalocean_tag.db_access.id
}

output "cluster_name" {
  value = var.cluster_name
}

output "region" {
  value = var.region
}

output "project_id" {
  value = digitalocean_project.project.id
}

output "cluster_address" {
  value = "${digitalocean_droplet.bootstrap_node.ipv4_address}:8443"
}

output "trust_token" {
  value = ssh_resource.trust_token.result
}