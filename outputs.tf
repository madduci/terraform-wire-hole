###################################
# nginx output information
###################################

# Comment the next section if nginx is disabled

output "nginx_image_digest" {
  value       = module.nginx.image_digest
  description = "The SHA256 Digest of the docker image"
}

output "nginx_service_address" {
  value       = module.nginx.service_address
  description = "The IPv4 Address (internal)"
}

output "nginx_public_address" {
  value       = module.nginx.public_address
  description = "The IPv4 Address (external)"
}

###################################
# NoIP output information
###################################

# Comment the next section if NoIP is disabled

output "noip_image_digest" {
  value       = module.noip.image_digest
  description = "The SHA256 Digest of the docker image"
}

output "noip_public_address" {
  value       = module.noip.public_address
  description = "The IPv4 Address (external)"
}

###################################
# WireGuard output information
###################################

# Comment the next section if WireGuard is disabled

output "wireguard_image_digest" {
  value       = module.wireguard.image_digest
  description = "The SHA256 Digest of the docker image"
}

output "wireguard_service_address" {
  value       = module.wireguard.service_address
  description = "The IPv4 Address (internal)"
}

output "wireguard_public_address" {
  value       = module.wireguard.public_address
  description = "The IPv4 Address (external)"
}

###################################
# PiHole output information
###################################

# Comment the next section if PiHole is disabled

output "cloudflared_image_digest" {
  value       = module.pihole.cloudflared_image_digest
  description = "The SHA256 Digest of the docker image"
}

output "cloudflared_service_address" {
  value       = module.pihole.cloudflared_service_address
  description = "The IPv4 Address (external)"
}

output "pihole_image_digest" {
  value       = module.pihole.pihole_image_digest
  description = "The SHA256 Digest of the docker image"
}

output "pihole_service_address" {
  value       = module.pihole.pihole_service_address
  description = "The IPv4 Address (internal)"
}
