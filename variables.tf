variable "do_token" {
  description = "Digital Ocean API Token"
}

variable "region" {
  description = "Region for your cluster"
  default = "sgp1"
}

variable "cluster_size" {
  description = "Define the size of your cluster"
}

variable "image" {
  description = "Image type of choice default is ubuntu 22.04 x86"
  default = "ubuntu-22-04-x64"
}

variable "project_name" {
  description = "Name for your project"
}

variable "size" {
  description = "Size of instances you want to use defaults to Basic 1GB instances https://slugs.do-api.dev/"
  default = "s-1vcpu-1gb"
}