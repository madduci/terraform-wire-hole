# Start the docker container

resource "docker_container" "cloudflared" {
  name    = "cloudflared"
  image   = docker_image.cloudflared.latest
  hostname = "cloudflared"
  restart = "always"
  env = [
    "TZ=${var.TIME_ZONE}",
  ]
  networks_advanced {
    name         = docker_network.service.name
    ipv4_address = var.internal_adresses["cloudflared"]
  }
}

# Find the latest image

data "docker_registry_image" "cloudflared" {
  name = "visibilityspots/cloudflared:latest"
}

# Updates the image dynamically

resource "docker_image" "cloudflared" {
  name          = data.docker_registry_image.cloudflared.name
  pull_triggers = [data.docker_registry_image.cloudflared.sha256_digest]
  keep_locally  = true
}
