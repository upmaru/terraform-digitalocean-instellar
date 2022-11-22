output "cluster_vpc_id" {
  value = digitalocean_vpc.cluster_vpc.id
}

output "cluster_name" {
  value = var.cluster_name
}

output "region" {
  value = var.region
}