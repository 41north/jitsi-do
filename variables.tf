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

variable "region" {
  default     = "lon1"
  description = "Region where the droplet will be deployed."
}

variable "droplet_image" {
  default     = "s-2vcpu-4gb"
  description = "Droplet image to be used."
}
