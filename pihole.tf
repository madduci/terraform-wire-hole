# Find the latest image

data "docker_registry_image" "pihole" {
  name = "pihole/pihole:latest"
}

# Updates the image dynamically

resource "docker_image" "pihole" {
  name          = data.docker_registry_image.pihole.name
  pull_triggers = [data.docker_registry_image.pihole.sha256_digest]
  keep_locally  = true
}

# Define the mountpoints as variable 

locals {
  pihole_config_dir  = "/infrastructure/pihole/etc-pihole"
  pihole_dnsmasq_dir = "/infrastructure/pihole/etc-dnsmasq.d"
  pihole_log_file    = "/dev/null"
}

# Start the docker container

resource "docker_container" "pihole" {
  name       = "pihole"
  image      = docker_image.pihole.latest
  hostname   = "pihole"
  restart    = "always"
  dns        = ["127.0.0.1"]
  depends_on = [docker_container.cloudflared]
  env = [
    "TZ=${var.TIME_ZONE}",
    "DNS1=10.0.0.10#5054",
    "DNS2=10.0.0.10#5054",
    "IPv6=false",
    "DNSMASQ_LISTENING=all",
    "PIHOLELOG=/dev/null"
  ]
  volumes {
    host_path      = local.pihole_config_dir
    container_path = "/etc/pihole"
  }
  volumes {
    host_path      = local.pihole_dnsmasq_dir
    container_path = "/etc/dnsmasq.d"
  }
  volumes {
    host_path      = local.pihole_log_file
    container_path = "/var/log/pihole.log"
    read_only      = true
  }
  networks_advanced {
    name         = docker_network.service.name
    ipv4_address = var.internal_adresses["pihole"]
  }
  ports {
    internal = 53
    external = 53
    protocol = "tcp"
  }
  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  capabilities {
    add = ["NET_ADMIN", "NET_BIND_SERVICE"]
  }
  healthcheck {
    test         = ["CMD", "curl", "--fail", "http://localhost/"]
    interval     = "20s"
    timeout      = "5s"
    start_period = "10s"
    retries      = 3
  }
}
