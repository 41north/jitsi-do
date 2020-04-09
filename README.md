# Jitsi Digital Ocean

Terraform recipe for running [Jitsi](https://jitsi.org/) on [DigitalOcean](https://digitalocean.com).

## Running

Clone this repository:

```sh
$ git clone https://github.com/41north/jitsi-do
```

Make sure you have installed [Terraform](https://www.terraform.io/downloads.html) on your system.

Rename `terraform.tfvars.example` to `terraform.tfvars` and fill the variables with your information. At least, you need to provide the following:

```terraform
variable "do_token" {
  default     = ""
  description = "Digital Ocean API Key: https://www.digitalocean.com/community/tutorials/how-to-create-a-digitalocean-space-and-api-key"
}

variable "domain" {
  default     = ""
  description = "Which domain is used by Jitsi."
}

variable "ssh_key_name" {
  default     = ""
  description = "Name of the SSH Digital Ocean keys to allow remote access to the droplet."
}
```

After everything is correctly filled, initialize terraform:

```sh
$ terraform init
```

And to review what is going to be created:

```sh
$ terraform plan
```

Once you're happy just trigger the `fire` button:

```sh
$ terraform apply
```

By default it will auto-install `jitsi` but it won't perform automatic SSL generation with Let's Encrypt. The reason is to control manually when to perform that step:

```sh
$ ssh -i .ssh/${your_ssh_key} root@${your_droplet_ip}
```

And run the following (replace `$EMAIL` with your email):

```sh
$ echo $EMAIL | /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
```

If everything goes well and the certification is creeated correctly, you can navigate to your domain and be greeted with Jitsi's dashboard!

> Au revoir, Zoom! :)

## Acknowledgements

Inspired by [Terraform AWS Jitsi Meet for AWS](https://github.com/AvasDream/terraform_aws_jitsi_meet).

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](./LICENSE) file for details.
