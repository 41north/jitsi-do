output "droplet_ip" {
  value = digitalocean_floating_ip.jitsi_floating_ip.ip_address
}
