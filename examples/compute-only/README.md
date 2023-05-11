## Basic Usage

Create a terraform script `main.tf` with the following:

```hcl
variable "do_token" {}
variable "cluster_name" {}
variable "node_size" {}

module "instellar" {
  source = "upmaru/instellar/digitalocean"
  version = "0.3.3"

  do_token     = var.do_token
  cluster_name = var.cluster_name
  vpc_ip_range = "10.0.2.0/24"
  cluster_topology = [
    { id = 1, name = "apple", size = var.node_size },
    { id = 2, name = "watermelon", size = var.node_size }
  ]
  node_size    = var.node_size
  storage_size = 50

  # SSH Keys added to digital account via UI
  ssh_keys = [
    "97:2f:5d:0d:4c:8d:13:8a:8f:4b:b8:74:c6:59:06:b7",
    "52:0d:1a:16:5e:64:22:28:1c:ec:3a:72:ce:2f:77:ba"
  ]
}

output "trust_token" {
  value = module.instellar.trust_token
}

output "cluster_address" {
  value = module.instellar.cluster_address
}
```

Create a file `.auto.tfvars` which should not be checked in with version control and add the credentials

```hcl
do_token = "<your do token>"
cluster_name = "fruits"
# https://slugs.do-api.dev/
node_size = "s-2vcpu-2gb-amd"
```

Simply run

```shell
terraform init
terraform plan
terraform apply
```

The example above will form a cluster with 3 nodes, one node will be called the `bootrap-node` this node will be used to co-ordinate and orchestrate the setup. With this configuration you will get 2 more nodes `apple` and `watermelon`. You can name the node anything you want.

If you wish to add a node into the cluster you can modify the `cluster_topology` variable.

```diff
cluster_topology = [
  {id = 1, name = "apple"},
  {id = 2, name = "watermelon"},
+ {id = 3, name = "orange"}
]
```

Then run `terraform apply` it will automatically scale your cluster up and add `orange` to the cluster. You can also selectively remove a node from the cluster.

```diff
cluster_topology = [
  {id = 1, name = "apple"},
- {id = 2, name = "watermelon"},
  {id = 3, name = "orange"}
]
```

Running `terraform apply` will gracefully remove `watermelon` from the cluster.

### Instance Type

You can specify the type of instance to use by specifying the size in the `cluster_topology`. Please use this [link](https://slugs.do-api.dev/) to reference the size of the nodes

```hcl
cluster_topology = [
  {id = 1, name = "apple", size = "s-2vcpu-2gb-amd"},
  {id = 2, name = "watermelon", size = "s-2vcpu-2gb-amd"},
  {id = 3, name = "orange", size = "s-2vcpu-2gb-amd"}
]
```
