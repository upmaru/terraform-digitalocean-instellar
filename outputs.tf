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

output "private_key" {
  value     = tls_private_key.bastion_key.private_key_openssh
  sensitive = true
}