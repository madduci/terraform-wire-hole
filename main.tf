# Set the required providers and versions

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

# Provider Definitions

provider "docker" {
  host = var.docker_host
}

##################################################
# Modules Definitions
##################################################

# Comment this out if you don't need nginx

module "nginx" {
  source                   = "./modules/nginx"
  docker_host              = var.docker_host
  image_name               = var.nginx_image_name
  time_zone                = var.time_zone
  domain_name              = var.domain_name
  domain_country           = var.domain_country
  domain_state             = var.domain_state
  domain_location          = var.domain_location
  domain_organisation      = var.domain_organisation
  domain_organisation_unit = var.domain_organisation_unit
  domain_common_name       = var.domain_common_name
  remote_user              = var.remote_user
  remote_folder            = var.remote_folder
  # Assign a fixed IPv4 Address on Public Network
  public_address = var.external_addresses["nginx"]
  # Define the name of the Public Network (created at root project level)
  public_network = var.docker_public_network_name
  # Assign a fixed IPv4 Address on Service (Private) Network
  service_address = var.internal_addresses["nginx"]
  # Define the name of the Service Network (created at root project level)
  service_network = var.docker_service_network_name
}

# Comment this out if you don't need NoIP

module "noip" {
  source      = "./modules/noip"
  docker_host = var.docker_host
  image_name  = var.noip_image_name
  time_zone   = var.time_zone
  # Assign a fixed IPv4 Address on Public Network
  public_address = var.external_addresses["noip"]
  # Define the name of the Public Network (created at root project level)
  public_network = var.docker_public_network_name
}

# Comment this out if you don't need PiHole

module "pihole" {
  source                 = "./modules/pihole"
  docker_host            = var.docker_host
  pihole_image_name      = var.pihole_image_name
  cloudflared_image_name = var.cloudflared_image_name
  time_zone              = var.time_zone
  # The Address of CloudFlared in the Service (Private) Network
  cloudflared_service_address = var.internal_addresses["cloudflared"]
  # Assign a fixed IPv4 Address on Service (Private) Network
  pihole_service_address = var.internal_addresses["pihole"]
  # Define the name of the Service Network (created at root project level)
  service_network = var.docker_service_network_name
}

# Comment this out if you don't need WireGuard

module "wireguard" {
  source      = "./modules/wireguard"
  docker_host = var.docker_host
  # Override this with var.wireguard_image_name if you want
  image_name  = var.wireguard_images[var.architecture]
  time_zone   = var.time_zone
  domain_name = var.domain_name
  peers       = var.wireguard_peers
  uid         = var.wireguard_uid
  gid         = var.wireguard_gid
  subnet      = var.wireguard_subnet
  # Use PiHole as DNS Server - Comment this out if PiHole is not required
  dns_server_address = var.internal_addresses["pihole"]
  # Assign a fixed IPv4 Address on Public Network
  public_address = var.external_addresses["wireguard"]
  # Define the name of the Public Network (created at root project level)
  public_network = var.docker_public_network_name
  # Assign a fixed IPv4 Address on Service (Private) Network
  service_address = var.internal_addresses["wireguard"]
  # Define the name of the Service Network (created at root project level)
  service_network = var.docker_service_network_name
}

