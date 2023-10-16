terraform {
	required_providers {
		digitalocean = {
			source = "digitalocean/digitalocean"
			version = "~> 2.0"
		}
	}
}

# from *.tfvars file
variable "ssh_pub_keys" {
  description = "List of SSH Keys (content)"
  type        = list(string)
  default     = []
}
variable "projet_name" {
	description = "Project Name"
	type        = string
}
variable "digitalocean_token" {
	description = "DigitalOcean API Token"
	type        = string
}
variable "digitalocean_region" {
	description = "DigitalOcean Region"
	type        = string
}

# setup the provider
provider "digitalocean" {
  token = var.digitalocean_token
}

# add project
resource "digitalocean_project" "project" {
  name        = upper(trim(var.projet_name))
  description = "A demo with Terraform"
}

# create vpc
resource "digitalocean_vpc" "network" {
	name     = "${var.projet_name}-network"
	region   = var.digitalocean_region
	ip_range = "10.10.10.0/28"
}

# create droplets (vps)
resource "digitalocean_droplet" "droplet_middleware" {
	name			= "${var.projet_name}-middleware"
	image			= "ubuntu-22-04-x64"
	size			= "s-1vcpu-512mb-10gb"
	region			= var.digitalocean_region
	ssh_keys		= var.ssh_pub_keys
	vpc_uuid		= digitalocean_vpc.network.id
}
resource "digitalocean_droplet" "droplet_application" {
	name			= "${var.projet_name}-application"
	image			= "ubuntu-22-04-x64"
	size			= "m-2vcpu-16gb"
	region			= var.digitalocean_region
	ssh_keys		= var.ssh_pub_keys
	vpc_uuid		= digitalocean_vpc.network.id
}
