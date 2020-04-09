terraform {
  required_version = ">= 0.12"
}

provider "digitalocean" {
  token = var.do_token
}

data "template_file" "install_script" {
  template = file("./scripts/install-jitsi.sh")
  vars = {
    email  = var.email
    domain = var.domain
  }
}

data "template_file" "letsencrypt" {
  template = file("./scripts/letsencrypt.sh")
  vars = {
    email  = var.email
    domain = var.domain
  }
}

data "digitalocean_ssh_key" "key" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "jitsi_server" {
  image              = "ubuntu-18-04-x64"
  name               = "jitsi-server"
  region             = var.region
  size               = var.droplet_image
  private_networking = true
  user_data          = format("%s", data.template_file.install_script.rendered)
  ssh_keys           = [data.digitalocean_ssh_key.key.id]

  provisioner "file" {
    source      = format("%s", data.template_file.letsencrypt.rendered)
    destination = "/root/letsencrypt.sh"
  }
}

resource "digitalocean_floating_ip" "jitsi_floating_ip" {
  droplet_id = digitalocean_droplet.jitsi_server.id
  region     = digitalocean_droplet.jitsi_server.region
}

resource "digitalocean_domain" "jitsi_domain" {
  name       = var.domain
  ip_address = digitalocean_droplet.jitsi_server.ipv4_address
}

resource "digitalocean_record" "jitsi_record" {
  domain = digitalocean_domain.jitsi_domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_floating_ip.jitsi_floating_ip.ip_address
}

resource "digitalocean_firewall" "jitsi_fw" {
  name = "jitsi-fw"

  droplet_ids = [digitalocean_droplet.jitsi_server.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "10000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "10000"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
