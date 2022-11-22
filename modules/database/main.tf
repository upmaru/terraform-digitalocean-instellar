provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_database_cluster" "database" {
  count                = var.should_create_db_cluster ? 1 : 0
  name                 = "${var.cluster_name}.${var.db_cluster_suffix}"
  engine               = var.engine
  version              = var.engine_version
  region               = var.region
  size                 = var.db_cluster_size
  node_count           = var.db_node_count
  private_network_uuid = var.cluster_vpc_id
}