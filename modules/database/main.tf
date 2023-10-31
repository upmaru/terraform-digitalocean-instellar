resource "digitalocean_database_cluster" "this" {
  name                 = "${var.identifier}-${var.engine}"
  engine               = var.engine
  version              = var.engine_version
  region               = var.region
  size                 = var.db_cluster_size
  node_count           = var.db_node_count
  private_network_uuid = var.cluster_vpc_id
}

resource "digitalocean_database_firewall" "this" {
  cluster_id = digitalocean_database_cluster.this.id

  rule {
    type  = "tag"
    value = var.db_access_tag_id
  }
}

resource "digitalocean_project_resources" "this" {
  project   = var.project_id
  resources = [
    digitalocean_database_cluster.this.urn
  ]
}