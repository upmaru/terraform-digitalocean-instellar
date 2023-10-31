variable "identifier" {}

variable "do_region" {}
variable "do_token" {}

variable "do_access_key" {}
variable "do_secret_key" {}

provider "digitalocean" {
  token = var.do_token

  spaces_access_id  = var.do_access_key
  spaces_secret_key = var.do_secret_key
}

locals {
  provider_name = "digitalocean"
}

module "bucket" {
  source = "../../modules/storage"

  bucket_name = var.identifier
  region      = var.do_region
}


module "networking_primary" {
  source = "../../modules/network"

  identifier   = var.identifier
  region       = var.do_region
  vpc_ip_range = "10.0.3.0/24"
}

module "compute_primary" {
  source = "../.."

  identifier = "${var.identifier}-a"

  vpc_id       = module.networking_primary.vpc_id
  vpc_ip_range = module.networking_primary.vpc_ip_range
  storage_size = 50
  node_size    = "s-2vcpu-4gb-amd"
  cluster_topology = [
    { id = 1, name = "01", size = "s-2vcpu-4gb-amd" },
    { id = 2, name = "02", size = "s-2vcpu-4gb-amd" }
  ]
  ssh_keys = []
}

module "database_primary" {
  source = "../../modules/database"

  identifier     = var.identifier
  engine         = "pg"
  engine_version = "15"
  region         = var.do_region
  db_size        = "db-s-1vcpu-1gb"
  db_node_count  = 1
  project_id     = module.compute_primary.project_id
  vpc_id         = module.networking_primary.vpc_id
  db_access_tags = [
    module.compute_primary.db_access_tag_id
  ]
}

variable "instellar_host" {}
variable "instellar_auth_token" {}

provider "instellar" {
  host       = var.instellar_host
  auth_token = var.instellar_auth_token
}

module "storage" {
  source  = "upmaru/bootstrap/instellar//modules/storage"
  version = "~> 0.5"

  bucket = module.bucket.name
  region = var.do_region
  host   = module.bucket.host

  access_key = var.do_access_key
  secret_key = var.do_secret_key
}

module "primary_cluster" {
  source  = "upmaru/bootstrap/instellar"
  version = "~> 0.5"

  cluster_name    = module.compute_primary.identifier
  region          = var.do_region
  provider_name   = local.provider_name
  cluster_address = module.compute_primary.cluster_address
  password_token  = module.compute_primary.trust_token

  bootstrap_node = module.compute_primary.bootstrap_node
  nodes          = module.compute_primary.nodes
}

module "postgresql_service" {
  source  = "upmaru/bootstrap/instellar//modules/service"
  version = "~> 0.5"

  slug           = module.database_primary.identifier
  provider_name  = local.provider_name
  driver         = "database/postgresql"
  driver_version = "15"

  cluster_ids = [
    module.primary_cluster.cluster_id
  ]

  channels = ["develop", "master"]
  credential = {
    username = module.database_primary.username
    password = module.database_primary.password
    resource = module.database_primary.db_name
    host     = module.database_primary.address
    port     = module.database_primary.port
    secure   = true
  }
}
