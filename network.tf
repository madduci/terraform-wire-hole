# public network

resource "docker_network" "public" {
  name            = "public_network"
  check_duplicate = true
  ipam_config {
    subnet = "192.168.10.0/24"
  }
}

# service network

resource "docker_network" "service" {
  name            = "service_network"
  check_duplicate = true
  ipam_config {
    subnet = "10.0.0.0/24"
  }
}

# IP Addresses

variable "internal_adresses" {
  type        = map(string)
  description = "Definition of default values for the internal addresses of services"

  default = {
    "nginx"       = "10.0.0.2"
    "cloudflared" = "10.0.0.10"
    "pihole"      = "10.0.0.11"
    "wireguard"   = "10.0.0.20"
  }
  # Mask the addresses
  sensitive = true
}

variable "external_adresses" {
  type        = map(string)
  description = "Definition of default values for the external addresses of services"

  default = {
    "nginx"   = "192.168.10.2"
    "noip"    = "192.168.10.3"
    wireguard = "192.168.10.20"
  }
}
