terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ssh = {
      source = "loafoe/ssh"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.31"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}