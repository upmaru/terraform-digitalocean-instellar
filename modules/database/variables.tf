variable "vpc_id" {
  description = "VPC ID"
}

variable "identifier" {
  description = "Name of your cluster"
}

variable "db_size" {
  description = "Size of your cluster see https://docs.digitalocean.com/reference/api/api-reference/#operation/registry_get_options"
  default     = "db-s-1vcpu-1gb"
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

variable "db_access_tags" {
  description = "Tags of nodes that have db access"
  type        = list(string)
}

variable "db_node_count" {
  description = "Node count for the database"
  default     = 1
}

variable "project_id" {
  description = "The project id to assign the database to"
}