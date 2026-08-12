terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "prview-ssh-key"
  public_key = file("${path.module}/id_ed25519.pub")
}

resource "digitalocean_droplet" "preview_k3s" {
  image    = "ubuntu-24-04-x64"
  name     = "pr-preview-k3s"
  region   = var.region
  size     = "s-2vcpu-4gb"
  ssh_keys = [digitalocean_ssh_key.default.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e
    # Wait for networking
    sleep 10
    
    # Get public IP for k3s certs
    PUBLIC_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
    
    # Install k3s (single node configuration)
    curl -sfL https://get.k3s.io | sh -s - server --tls-san $PUBLIC_IP
  EOF
}

resource "digitalocean_firewall" "preview_fw" {
  name = "pr-preview-firewall"

  droplet_ids = [digitalocean_droplet.preview_k3s.id]

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

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
