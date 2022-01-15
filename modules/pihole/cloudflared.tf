# Find the latest image

data "docker_registry_image" "cloudflared" {
  name = var.cloudflared_image_name
}

# Updates the image dynamically

resource "docker_image" "cloudflared" {
  name          = data.docker_registry_image.cloudflared.name
  pull_triggers = [data.docker_registry_image.cloudflared.sha256_digest]
  keep_locally  = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "docker_container" "cloudflared" {
  name     = "cloudflared"
  image    = docker_image.cloudflared.latest
  hostname = "cloudflared"
  restart  = "always"
  env = [
    "TZ=${var.time_zone}",
  ]
  
  # Network
  networks_advanced {
    name         = var.service_network
    ipv4_address = var.cloudflared_service_address
  }
}