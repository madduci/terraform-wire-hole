output "pihole_image_digest" {
  value       = data.docker_registry_image.pihole.sha256_digest
  description = "The SHA256 Digest of the docker image"
}

output "pihole_service_address" {
  value       = var.pihole_service_address
  description = "The IPv4 Address (internal)"
}

output "cloudflared_image_digest" {
  value       = data.docker_registry_image.cloudflared.sha256_digest
  description = "The SHA256 Digest of the docker image"
}

output "cloudflared_service_address" {
  value       = var.cloudflared_service_address
  description = "The IPv4 Address (internal)"
}
