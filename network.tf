# public network

resource "docker_network" "public" {
  name            = var.docker_public_network_name
  check_duplicate = true
  ipam_config {
    subnet = "192.168.10.0/24"
  }
  lifecycle { create_before_destroy = true }
}

# service network

resource "docker_network" "service" {
  name            = var.docker_service_network_name
  check_duplicate = true
  ipam_config {
    subnet = "10.0.0.0/24"
  }
  lifecycle { create_before_destroy = true }
}
