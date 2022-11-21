variable "do_token" {
  description = "Digital Ocean API Token"
}

variable "region" {
  description = "Region for your cluster"
  default     = "sgp1"
}

variable "cluster_size" {
  description = "Define the size of your cluster"
  default     = 1
}

variable "cluster_name" {
  description = "Name for your project"
}

variable "image" {
  description = "Image type of choice default is ubuntu 22.04 x86"
  default     = "ubuntu-22-04-x64"
}

variable "environment" {
  description = "Environment for project in Digital Ocean possible values are Development, Staging, Production"
  default     = "Production"
}

variable "vpc_ip_range" {
  description = "The IP range to use for VPC"
  default     = "10.0.1.0/24"
}

variable "bastion_size" {
  description = "Size of the bastion instance defaults to Basic 512MB instance https://slugs.do-api.dev/"
  default     = "s-1vcpu-512mb-10gb"
}

variable "node_size" {
  description = "Size of instances you want to use defaults to Basic 1GB instances https://slugs.do-api.dev/"
  default     = "s-1vcpu-1gb"
}

variable "ssh_keys" {
  type        = list(number)
  description = "List of ssh keys retrieved using doctl compute ssh-key list"
  default     = []
}