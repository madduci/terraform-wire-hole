

# Define the image to be used
data "docker_registry_image" "nginx" {
  name = var.image_name
}

# Update the image dynamically, if the tag is the constant
resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
  keep_locally  = true
  lifecycle {
    create_before_destroy = true
  }
}

# Define the docker container

resource "docker_container" "nginx" {
  image    = docker_image.nginx.latest
  name     = "nginx"
  hostname = "nginx"
  restart  = "always"
  depends_on = [
    null_resource.nginx_certs
  ]
  # Environment
  env = [
    "TZ=${var.time_zone}",
    "NGINX_HOST=${var.domain_name}"
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
    container_path = "/etc/ssl/${var.domain_name}/dhparam-2048.pem"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_server_cert
    container_path = "/etc/ssl/${var.domain_name}/certificate.pem"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_server_key
    container_path = "/etc/ssl/${var.domain_name}/key.pem"
    read_only      = true
  }
  volumes {
    host_path      = local.nginx_webroot_folder
    container_path = "/usr/share/nginx/html"
    read_only      = true
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
