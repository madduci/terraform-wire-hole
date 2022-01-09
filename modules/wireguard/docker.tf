# Find the latest image

data "docker_registry_image" "wireguard" {
  name = var.image_name
}

# Updates the image dynamically

resource "docker_image" "wireguard" {
  name          = data.docker_registry_image.wireguard.name
  pull_triggers = [data.docker_registry_image.wireguard.sha256_digest]
  keep_locally  = true
  lifecycle {
    create_before_destroy = true
  }
}

# Start the docker container

resource "docker_container" "wireguard" {
  image    = docker_image.wireguard.latest
  name     = "wireguard"
  hostname = "wireguard"
  restart  = "always"

  # Environment
  env = [
    "TZ=${var.time_zone}",
    "PUID=${var.uid}",
    "GUID=${var.gid}",
    "SERVERURL=${var.domain_name}",
    "PEERS=${var.peers}",
    "PEER_DNS=${var.dns_server_address}",
    "INTERNAL_SUBNET=${var.subnet}"
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
    name         = var.service_network
    ipv4_address = var.service_address
  }
  networks_advanced {
    name         = var.public_network
    ipv4_address = var.public_address
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
