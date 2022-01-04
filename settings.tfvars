#################################
# General Settings
#################################

docker_host                 = "unix:///var/run/docker.sock"
architecture                = "amd64"
docker_public_network_name  = "public_network"
docker_service_network_name = "service_network"
time_zone                   = "Europe/Berlin"
domain_name                 = "YOUR_DOMAIN"
remote_user                 = ""
remote_folder               = ""

#################################
# nginx Settings
#################################

nginx_image_name         = "nginx:alpine"
domain_country           = "YOUR_COUNTRY_CODE"
domain_state             = "YOUR_STATE"
domain_location          = "YOUR_LOCATION"
domain_organisation      = "YOUR_ORGANISATION"
domain_organisation_unit = "YOUR_ORGANISATION_UNIT"
domain_common_name       = "YOUR_DOMAIN"

#################################
# PiHole Settings
#################################

pihole_image_name      = "pihole/pihole:latest"
cloudflared_image_name = "visibilityspots/cloudflared:latest"

#################################
# WireGuard Settings
#################################

# Explicitly set the image, if necessary (requires correction in main.tf Module)
#wireguard_image_name        = "linuxserver/wireguard:amd64-latest"
wireguard_subnet   = "10.13.13.0"
wireguard_peersdns = "1.1.1.1"
wireguard_peers    = "1"
wireguard_uid      = "1000"
wireguard_gid      = "1000"

#################################
# NoIP Settings
#################################

noip_image_name = "romeupalos/noip:latest"