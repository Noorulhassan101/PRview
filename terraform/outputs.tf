output "vm_public_ip" {
  value       = digitalocean_droplet.preview_k3s.ipv4_address
  description = "The public IP address of the provisioned VM"
}

output "sslip_domain" {
  value       = "pr-<NUMBER>.${replace(digitalocean_droplet.preview_k3s.ipv4_address, ".", "-")}.sslip.io"
  description = "Example of the sslip.io domain format to use"
}
