# Find the latest image

data "docker_registry_image" "nginx" {
  name = "nginx:alpine"
}

# Updates the image dynamically

resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
  keep_locally  = true
}

# Define the mountpoints as variable 

locals {
  nginx_default_conf    = "/infrastructure/nginx/config/templates/default.conf"
  nginx_proxy_conf      = "/infrastructure/nginx/config/templates/proxy.conf"
  nginx_server_dhparams = "/infrastructure/nginx/config/ssl/dhparam-2048.pem"
  nginx_server_cert     = "/infrastructure/nginx/config/ssl/certificate.pem"
  nginx_server_key      = "/infrastructure/nginx/config/ssl/key.pem"
  nginx_webroot_folder  = "/infrastructure/nginx/webroot"
}

# Start the docker container

resource "docker_container" "nginx" {
  image      = docker_image.nginx.latest
  depends_on = [docker_container.pihole]
  name       = "nginx"
  hostname   = "nginx"
  restart    = "always"

  # Environment
  env = [
    "TZ=${var.TIME_ZONE}",
    "NGINX_HOST=${var.DOMAIN_NAME}"
  ]

  # Volumes
  volumes {
    host_path      = local.nginx_default_conf
    container_path = "/etc/nginx/templates/default.conf.template"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_proxy_conf
    container_path = "/etc/nginx/includes/proxy.conf"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_server_dhparams
    container_path = "/etc/ssl/${var.DOMAIN_NAME}/dhparam-2048.pem"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_server_cert
    container_path = "/etc/ssl/${var.DOMAIN_NAME}/certificate.pem"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_server_key
    container_path = "/etc/ssl/${var.DOMAIN_NAME}/key.pem"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_webroot_folder
    container_path = "/usr/share/nginx/html"
    read_only      = true
  }

  # Network
  networks_advanced {
    name         = docker_network.service.name
    ipv4_address = var.internal_adresses["nginx"]
  }
  networks_advanced {
    name         = docker_network.public.name
    ipv4_address = var.external_adresses["nginx"]
  }

  # Ports
  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }
  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }

  # Healthcheck
  healthcheck {
    test         = ["CMD", "curl", "--insecure", "--fail", "https://localhost/"]
    interval     = "20s"
    timeout      = "5s"
    start_period = "10s"
    retries      = 3
  }
}
