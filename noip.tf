# Find the latest image

data "docker_registry_image" "noip" {
  name = "romeupalos/noip:latest"
}

# Updates the image dynamically

resource "docker_image" "noip" {
  name          = data.docker_registry_image.noip.name
  pull_triggers = [data.docker_registry_image.noip.sha256_digest]
  keep_locally  = true
}

# Define the mountpoints as variable 

locals {
  noip_conf = "/infrastructure/noip/config/no-ip2.conf"
}

# Start the docker container

resource "docker_container" "noip" {
  image    = docker_image.noip.latest
  name     = "noip"
  hostname = "noip"
  restart  = "always"
  # Environment
  env = [
    "TZ=${var.TIME_ZONE}",
  ]

  # Volumes
  volumes {
    host_path      = local.noip_conf
    container_path = "/usr/local/etc/no-ip2.conf"
  }

  # Network
  networks_advanced {
    name         = docker_network.public.name
    ipv4_address = var.external_adresses["noip"]
  }

}
