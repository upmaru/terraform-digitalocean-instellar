output "identifier" {
  value = "${var.identifier}-${var.engine}"
}

output "address" {
  value = digitalocean_database_cluster.this.private_host
}

output "username" {
  value = digitalocean_database_cluster.this.user
}

output "password" {
  value = digitalocean_database_cluster.this.password
}

output "port" {
  value = digitalocean_database_cluster.this.port
}

output "db_name" {
  value = digitalocean_database_cluster.this.database
}

output "engine_version" {
  value = var.engine_version
}

output "certificate" {
  value = data.digitalocean_database_ca.this.certificate
}
