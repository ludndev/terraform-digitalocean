# Terraform Infrastructure Deployment for DigitalOcean

This repository contains Terraform configuration files to deploy a simple infrastructure on DigitalOcean. This infrastructure includes the creation of a VPC, two Droplets (virtual machines), a domain, and a Spaces bucket.

## Prerequisites

Before you can use these Terraform configurations, make sure you have the following prerequisites in place:

- [Terraform](https://www.terraform.io/) installed on your local machine.
- A [DigitalOcean][(https://www.digitalocean.com/](https://m.do.co/c/35cefa19b08f)) account.
- DigitalOcean API Token for authentication.
- Your DigitalOcean Spaces secret key for accessing Spaces resources.

## Getting Started

1. Clone this repository to your local machine.

2. Create a `digitalocean.tfvars` file in the same directory as the Terraform configuration files with the following content:

```hcl
# List of SSH keys
ssh_pub_keys = []

# Your project name
projet_name = "demo"

# Your project description
projet_description = "Your project description"

# Your desired domain name
projet_domain = "example.com"

# Your DigitalOcean Personal API Token
digitalocean_token = "your_digitalocean_api_token"

# Choose your preferred region
digitalocean_region = "nyc1"

# Your DigitalOcean Spaces access id
digitalocean_spaces_access_id = "your_spaces_access_id"

# Your DigitalOcean Spaces secret key
digitalocean_spaces_secret_key = "your_spaces_secret_key"

# List of permitted origin domains for accessing your DigitalOcean Spaces bucket
digitalocean_spaces_allowed_origins = ["https://www.example.com"]  # Origins for PUT, POST, DELETE requests
```

3. Customize the `digitalocean.tfvars` file with your specific values.

4. Initialize Terraform by running the following command in the repository directory:

```bash
terraform init  -var-file=digitalocean.tfvars
```

5. Deploy the infrastructure by running:

```bash
terraform apply -var-file=digitalocean.tfvars
```

Confirm the changes when prompted.

## Terraform Configuration

- The `main.tf` file contains the Terraform configuration, including the DigitalOcean provider setup and the definition of various resources such as VPC, Droplets, Domain, and Spaces bucket.

- The resources are parameterized using variables, and their values can be provided via the `digitalocean.tfvars` file.

## Cleaning Up

To destroy the infrastructure and clean up resources, run the following command:

```bash
terraform destroy -var-file=digitalocean.tfvars
```

Confirm the destruction when prompted.

## Outputs

After deploying the infrastructure, you can retrieve the following information using the `terraform output` command:

- `output_server_middleware_ips`: IP address of the middleware Droplet.
- `output_server_application_ips`: IP address of the application Droplet.

## Conclusion

This Terraform configuration automates the deployment of a simple infrastructure on DigitalOcean. You can customize it further by providing your specific values in the `digitalocean.tfvars` file. For more details on Terraform and DigitalOcean resources, refer to the official [Terraform documentation](https://www.terraform.io/docs/) and [DigitalOcean documentation](https://www.digitalocean.com/docs/).

## License

This project is licensed under the [3-Clause BSD License](LICENSE) to encourage collaboration and use, with some restrictions. Please review the full license text provided in the [LICENSE](LICENSE) file for more details.
