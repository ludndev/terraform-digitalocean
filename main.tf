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
variable "projet_description" {
	description = "Project Description"
	type        = string
}
variable "projet_domain" {
	description = "Project Domain Name"
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
variable "digitalocean_spaces_access_id" {
	description = "DigitalOcean Spaces Access ID"
	type        = string
}
variable "digitalocean_spaces_secret_key" {
	description = "DigitalOcean Spaces Secret KEY"
	type        = string
}
variable "digitalocean_spaces_allowed_origins" {
	description = "List of allowed origins to modify on DigitalOcean Storage"
	type        = list(string)
	default     = []
}

# setup the provider
provider "digitalocean" {
  token = var.digitalocean_token
}

# add project
resource "digitalocean_project" "project" {
  name        = upper(trimspace(var.projet_name))
  description = var.projet_description
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

# create a new domain
resource "digitalocean_domain" "domain" {
	name       = var.projet_domain
	ip_address = digitalocean_droplet.droplet_application.ipv4_address
}

# create storage (spaces)
resource "digitalocean_spaces_bucket" "spaces_storage" {
	name   = "${var.projet_name}-storage"
	region = var.digitalocean_region
}
resource "digitalocean_spaces_bucket_cors_configuration" "spaces_storage_cors" {
	bucket = digitalocean_spaces_bucket.spaces_storage.id
	region = var.digitalocean_region
	cors_rule {
		allowed_headers = ["*"]
		allowed_methods = ["GET"]
		allowed_origins = ["*"]
		max_age_seconds = 3000
	}
	cors_rule {
		allowed_headers = ["*"]
		allowed_methods = ["GET", "PUT", "POST", "DELETE"]
		allowed_origins = var.digitalocean_spaces_allowed_origins
		max_age_seconds = 3000
	}
}

# add resources to project
resource "digitalocean_project_resources" "project_resource" {
	project = digitalocean_project.project.id
	resources = [
		digitalocean_droplet.droplet_middleware.urn,
		digitalocean_droplet.droplet_application.urn,
		digitalocean_spaces_bucket.spaces_storage.urn,
	]
}

# output
output "output_server_middleware_ips" {
	value = digitalocean_droplet.droplet_middleware.ipv4_address
}
output "output_server_application_ips" {
	value = digitalocean_droplet.droplet_application.ipv4_address
}
