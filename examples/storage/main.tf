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

module "bucket" {
  source = "../../modules/storage"

  bucket_name = var.identifier
  region      = var.do_region
}
