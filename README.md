# Terraform for Instellar

This repository is used to store all terraform files for bootstrapping clusters to be used with instellar.app

This is the setup that is recommended for hosting production apps. It sets up the following components

+ [Bastion](#bastion) 
+ [Nodes](#nodes)
+ [VPC](#vpc)
+ [Firewall Rules](#firewall-rules)

## Design

![scope](/assets/scope.jpg)

## Bastion

This is the node that will be used to access the internal network. This will be the only node that is directly exposed by design.

You will need to ssh into this node and use this node to access all the other nodes.

## Nodes

You can have multiple nodes in a cluster. This is where your apps will run.

## VPC

This is the virtual private cloud that hosts all your nodes. It provides private ip addresses for your nodes

## Firewall Rules

These are the rules that govern the incoming / outgoing traffic from your nodes.