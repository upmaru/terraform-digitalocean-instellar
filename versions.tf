terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}