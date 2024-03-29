variable "region" {
  description = "Region for your cluster"
  default     = "sgp1"
}

variable "protect_leader" {
  type        = bool
  description = "Protect database leader node"
  default     = true
}

variable "storage_size" {
  description = "Storage size to use with cluster"
}

variable "identifier" {
  description = "Name for your cluster"
}

variable "image" {
  description = "Image type of choice default is ubuntu 22.04 x86"
  default     = "ubuntu-22-04-x64"
}

variable "vpc_id" {
  description = "vpc id to pass in from the network module"
  type = string
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
  default     = "s-2vcpu-4gb-amd"
}

variable "project_id" {
  description = "Project ID reference"
}
 
variable "cluster_topology" {
  type = list(object({
    id   = number
    name = string
    size = optional(string, "s-1vcpu-1gb")
  }))
  description = "How many nodes do you want in your cluster?"
  default     = []
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of ssh keys fingerprint"
  default     = []
}