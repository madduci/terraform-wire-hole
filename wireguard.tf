# Find the latest image

data "docker_registry_image" "wireguard" {
  name = "linuxserver/wireguard:${var.ARCHITECTURE}-latest"
}

# Updates the image dynamically

resource "docker_image" "wireguard" {
  name          = data.docker_registry_image.wireguard.name
  pull_triggers = [data.docker_registry_image.wireguard.sha256_digest]
  keep_locally  = true
}

# Define local variables

locals {
  wireguard_peer_dns       = var.internal_adresses["pihole"]
  wireguard_modules_folder = "/lib/modules"
  wireguard_config_folder  = "/infrastructure/wireguard/config"
}

# Start the docker container

resource "docker_container" "wireguard" {
  image      = docker_image.wireguard.latest
  depends_on = [docker_container.nginx, docker_container.noip, docker_container.pihole]
  name       = "wireguard"
  hostname   = "wireguard"
  restart    = "always"

  # Environment
  env = [
    "TZ=${var.TIME_ZONE}",
    "PUID=${var.WIREGUARD_UID}",
    "GUID=${var.WIREGUARD_GID}",
    "SERVERURL=${var.DOMAIN_NAME}",
    "PEERS=${var.WIREGUARD_PEERS}",
    "PEER_DNS=${local.wireguard_peer_dns}",
    "INTERNAL_SUBNET=${var.WIREGUARD_SUBNET}"
  ]

  # Volumes
  volumes {
    host_path      = local.wireguard_modules_folder
    container_path = "/lib/modules"
    read_only      = true
  }
  volumes {
    host_path      = local.wireguard_config_folder
    container_path = "/config"
  }

  # Network
  networks_advanced {
    name         = docker_network.service.name
    ipv4_address = var.internal_adresses["wireguard"]
  }
  networks_advanced {
    name         = docker_network.public.name
    ipv4_address = var.external_adresses["wireguard"]
  }

  # Ports
  ports {
    internal = 51820
    external = 51820
    protocol = "udp"
  }

  # Capabilities
  capabilities {
    add = ["NET_ADMIN", "SYS_MODULE"]
  }

  # System Controls
  sysctls = {
    "net.ipv4.conf.all.src_valid_mark" = "1"
  }

}
