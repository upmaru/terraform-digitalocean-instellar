variable "do_token" {
  description = "Digital Ocean API Token"
  sensitive   = true
}

variable "cluster_vpc_id" {
  description = "Cluster VPC Id"
}

variable "cluster_name" {
  description = "Name of your cluster"
}

variable "db_cluster_size" {
  description = "Size of your cluster see https://docs.digitalocean.com/reference/api/api-reference/#operation/registry_get_options"
  default     = "db-s-1vcpu-1gb"
}

variable "db_cluster_suffix" {
  description = "Suffix for cluster name"
}

variable "engine" {
  description = "Define the database engine to use"
  default     = "pg"
}

variable "engine_version" {
  description = "PostgreSQL version"
  default     = "13"
}

variable "region" {
  description = "Region for your cluster"
}

variable "db_access_tag_id" {
  description = "Tag given to nodes that have db access"
}

variable "should_create_db_cluster" {
  description = "Should we create the db cluster?"
  type        = bool
  default     = true
}

variable "db_node_count" {
  description = "Node count for the database"
  default     = 1
}