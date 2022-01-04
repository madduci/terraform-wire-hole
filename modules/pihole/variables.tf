variable "docker_host" {
  type        = string
  description = "The Path to local unix docker socket or a remote SSH connection string to a host where docker is running"
  validation {
    condition     = can(regex("^[unix|ssh].*$", var.docker_host))
    error_message = "The docker_host value must be set. Allowed strings are in format 'unix:///var/run/docker.sock' or 'ssh://USERNAME@REMOTE_HOST:REMOTE_PORT'."
  }
}

variable "pihole_image_name" {
  type        = string
  description = "The Docker Image name to download for PiHole. Defaults to pihole/pihole:latest"
  default     = "pihole/pihole:latest"
  validation {
    condition     = length(var.pihole_image_name) > 0
    error_message = "The pihole_image_name value must be set."
  }
}

variable "cloudflared_image_name" {
  type        = string
  description = "The Docker Image name to download for CloudFlared. Defaults to pihole/pihole:latest"
  default     = "visibilityspots/cloudflared:latest"
  validation {
    condition     = length(var.cloudflared_image_name) > 0
    error_message = "The cloudflared_image_name value must be set."
  }
}

variable "time_zone" {
  type        = string
  description = "The timezone to be used (default: Europe/Berlin)"
  default     = "Europe/Berlin"

  validation {
    condition     = length(var.time_zone) > 0
    error_message = "Invalid time_zone specified."
  }
}


variable "service_network" {
  type        = string
  description = "The name of the docker service (private) network"
  validation {
    condition     = length(var.service_network) > 4
    error_message = "The service_network value must be a defined."
  }
}

variable "pihole_service_address" {
  type        = string
  description = "The IPv4 Address of the PiHole service, facing the service network"
  validation {
    condition     = length(var.pihole_service_address) > 4
    error_message = "The pihole_service_address value must be a defined."
  }
}

variable "cloudflared_service_address" {
  type        = string
  description = "The IPv4 Address of the CloudFlared service, facing the service network"
  validation {
    condition     = length(var.cloudflared_service_address) > 4
    error_message = "The cloudflared_service_address value must be a defined."
  }
}


# Define the mountpoints as variable 

locals {
  pihole_config_dir  = "${abspath(path.module)}/pihole/etc-pihole"
  pihole_dnsmasq_dir = "${abspath(path.module)}/pihole/etc-dnsmasq.d"
  pihole_log_file    = "/dev/null"
}
