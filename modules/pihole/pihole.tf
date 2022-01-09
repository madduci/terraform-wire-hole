# Find the latest image

data "docker_registry_image" "pihole" {
  name = var.pihole_image_name
}

# Updates the image dynamically

resource "docker_image" "pihole" {
  name          = data.docker_registry_image.pihole.name
  pull_triggers = [data.docker_registry_image.pihole.sha256_digest]
  keep_locally  = true
  lifecycle {
    create_before_destroy = true
  }
}

# Start the docker container

resource "docker_container" "pihole" {
  name     = "pihole"
  image    = docker_image.pihole.latest
  hostname = "pihole"
  restart  = "always"
  dns      = ["127.0.0.1"]
  depends_on = [
    docker_container.cloudflared
  ]
  env = [
    "TZ=${var.time_zone}",
    "DNS1=${var.cloudflared_service_address}#5054",
    "DNS2=${var.cloudflared_service_address}#5054",
    "IPv6=false",
    "DNSMASQ_LISTENING=all",
    "PIHOLELOG=/dev/null"
  ]
  volumes {
    host_path      = local.pihole_etc_folder
    container_path = "/etc/pihole"
  }
  volumes {
    host_path      = local.pihole_dnsmasq_folder
    container_path = "/etc/dnsmasq.d"
  }
  volumes {
    host_path      = local.pihole_log_file
    container_path = "/var/log/pihole.log"
    read_only      = true
  }
  networks_advanced {
    name         = var.service_network
    ipv4_address = var.pihole_service_address
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
