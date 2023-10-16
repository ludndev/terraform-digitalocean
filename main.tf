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
