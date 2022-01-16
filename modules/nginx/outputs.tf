output "image_digest" {
  value       = data.docker_registry_image.nginx.sha256_digest
  description = "The SHA256 Digest of the docker image"
}

output "service_address" {
  value       = var.service_address
  description = "The IPv4 Address (internal)"
}

output "public_address" {
  value       = var.public_address
  description = "The IPv4 Address (external)"
}
