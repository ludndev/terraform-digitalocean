terraform {
	required_providers {
		digitalocean = {
			source = "digitalocean/digitalocean"
			version = "~> 2.0"
		}
	}
}

# from *.tfvars file
variable "projet_name" {
	description = "Project Name"
	type        = string
}
variable "digitalocean_token" {
	description = "DigitalOcean API Token"
	type        = string
}

# setup the provider
provider "digitalocean" {
  token = var.digitalocean_token
}
