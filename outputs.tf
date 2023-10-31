output "db_access_tag_id" {
  value = digitalocean_tag.db_access.id
}

output "identifier" {
  value = var.identifier
}

output "region" {
  value = var.region
}

output "project_id" {
  value = digitalocean_project.project.id
}

output "cluster_address" {
  value = digitalocean_droplet.bootstrap_node.ipv4_address
}

output "trust_token" {
  value = ssh_resource.trust_token.result
}

output "bootstrap_node" {
  value = {
    slug      = digitalocean_droplet.bootstrap_node.name
    public_ip = digitalocean_droplet.bootstrap_node.ipv4_address
  }
}

output "nodes" {
  value = [
    for key, node in digitalocean_droplet.nodes :
    {
      slug      = node.name
      public_ip = node.ipv4_address
    }
  ]
}