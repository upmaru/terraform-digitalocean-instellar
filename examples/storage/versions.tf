terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.31"
    }

    instellar = {
      source  = "upmaru/instellar"
      version = "~> 0.6"
    }
  }
}
