# Find the latest image

data "docker_registry_image" "noip" {
  name = var.image_name
}

# Updates the image dynamically

resource "docker_image" "noip" {
  name          = data.docker_registry_image.noip.name
  pull_triggers = [data.docker_registry_image.noip.sha256_digest]
  keep_locally  = true
  lifecycle {
    create_before_destroy = true
  }
}

# Start the docker container

resource "docker_container" "noip" {
  image    = docker_image.noip.latest
  name     = "noip"
  hostname = "noip"
  restart  = "always"
  depends_on = [
    null_resource.remote_upload_config
  ]
  # Environment
  env = [
    "TZ=${var.time_zone}",
  ]

  # Volumes
  volumes {
    host_path      = local.noip_conf
    container_path = "/usr/local/etc/no-ip2.conf"
  }

  # Network
  networks_advanced {
    name         = var.public_network
    ipv4_address = var.public_address
  }

}
