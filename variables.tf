######################################### 
# General Settings
#########################################

variable "docker_host" {
  type        = string
  description = "The Path to local unix docker socket or a remote SSH connection string to a host where docker is running"
  validation {
    condition     = can(regex("^[unix|ssh].*$", var.docker_host))
    error_message = "The docker_host value must be set. Allowed strings are in format 'unix:///var/run/docker.sock' or 'ssh://USERNAME@REMOTE_HOST:REMOTE_PORT'."
  }
}

variable "docker_public_network_name" {
  type        = string
  description = "The name of the docker public network"
  validation {
    condition     = length(var.docker_public_network_name) > 4
    error_message = "The docker_public_network_name value must be a defined."
  }
}

variable "docker_service_network_name" {
  type        = string
  description = "The name of the docker service (private) network"
  validation {
    condition     = length(var.docker_service_network_name) > 4
    error_message = "The docker_service_network_name value must be a defined."
  }
}

variable "architecture" {
  type        = string
  description = "The target host architecture. Valid values are: amd64, arm64v8, or arm32v7."

  validation {
    condition     = contains(["amd64", "arm64v8", "arm32v7"], var.architecture)
    error_message = "Invalid architecture specified. Valid values are: amd64, arm64v8, or arm32v7."
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

variable "remote_user" {
  type        = string
  description = "The remote user name"
  default     = ""
}

variable "remote_folder" {
  type        = string
  description = "The remote folder where to store the configuration files"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "The domain name used for the configuration"
  validation {
    condition     = length(var.domain_name) > 4
    error_message = "The domain_name value must be a valid domain name."
  }
}

variable "internal_addresses" {
  type        = map(string)
  description = "Definition of default values for the internal addresses of services"

  default = {
    "nginx"       = "10.0.0.2"
    "cloudflared" = "10.0.0.10"
    "pihole"      = "10.0.0.11"
    "wireguard"   = "10.0.0.20"
  }
}

variable "external_addresses" {
  type        = map(string)
  description = "Definition of default values for the external addresses of services"

  default = {
    "nginx"     = "192.168.10.2"
    "noip"      = "192.168.10.3"
    "wireguard" = "192.168.10.20"
  }
}

######################################### 
# NoIP Settings
#########################################

# Comment out the following variables if you don't need the NoIP module

variable "noip_image_name" {
  type        = string
  description = "The Docker Image for NoIp. Defaults to romeupalos/noip:latest"
  default     = "romeupalos/noip:latest"
  validation {
    condition     = length(var.noip_image_name) > 0
    error_message = "The noip_image_name value must be set."
  }
}

######################################### 
# nginx Settings
#########################################

# Comment out the following variables if you don't need the nginx module

variable "nginx_image_name" {
  type        = string
  description = "The Docker Image for nginx. Defaults to nginx:alpine"
  default     = "nginx:alpine"
  validation {
    condition     = length(var.nginx_image_name) > 0
    error_message = "The nginx_image_name value must be set."
  }
}

variable "domain_country" {
  type        = string
  description = "The Country Code (C) required for issuing a TLS certificate"

  validation {
    condition     = length(var.domain_country) > 0
    error_message = "Invalid domain_country specified."
  }
}

variable "domain_state" {
  type        = string
  description = "The State/Province (ST) required for issuing a TLS certificate"

  validation {
    condition     = length(var.domain_state) > 0
    error_message = "Invalid domain_state specified."
  }
}

variable "domain_location" {
  type        = string
  description = "The Location (L) required for issuing a TLS certificate"

  validation {
    condition     = length(var.domain_location) > 0
    error_message = "Invalid domain_location specified."
  }
}

variable "domain_organisation" {
  type        = string
  description = "The Organisation (O) required for issuing a TLS certificate"

  validation {
    condition     = length(var.domain_organisation) > 0
    error_message = "Invalid domain_organisation specified."
  }
}

variable "domain_organisation_unit" {
  type        = string
  description = "The Organisation Unit (OU) required for issuing a TLS certificate"

  validation {
    condition     = length(var.domain_organisation_unit) > 0
    error_message = "Invalid domain_organisation_unit specified."
  }
}

variable "domain_common_name" {
  type        = string
  description = "The Common Name (CN) required for issuing a TLS certificate"

  validation {
    condition     = length(var.domain_common_name) > 0
    error_message = "Invalid domain_common_name specified."
  }
}

######################################### 
# PiHole Settings
#########################################

# Comment out the following variables if you don't need the PiHole module.
# Beware: PiHole is required for WireGuard to be fully operative

variable "pihole_image_name" {
  type        = string
  description = "The Docker Image for PiHole. Defaults to pihole/pihole:latest"
  default     = "pihole/pihole:latest"
  validation {
    condition     = length(var.pihole_image_name) > 0
    error_message = "The pihole_image_name value must be set."
  }
}

variable "cloudflared_image_name" {
  type        = string
  description = "The Docker Image for CloudFlared. Defaults to pihole/pihole:latest"
  default     = "visibilityspots/cloudflared:latest"
  validation {
    condition     = length(var.cloudflared_image_name) > 0
    error_message = "The cloudflared_image_name value must be set."
  }
}

######################################### 
# WireGuard Settings
#########################################

# Comment out the following variables if you don't need the WireGuard module

variable "wireguard_image_name" {
  type        = string
  description = "The Docker Image for WireGuard. Defaults to linuxserver/wireguard:amd64-latest"
  default     = "linuxserver/wireguard:amd64-latest"
  validation {
    condition     = length(var.wireguard_image_name) > 0
    error_message = "The wireguard_image_name value must be set."
  }
}

variable "wireguard_images" {
  type        = map(string)
  description = "The list of Docker Images for WireGuard."

  default = {
    "amd64"   = "linuxserver/wireguard:amd64-latest"
    "arm64v8" = "linuxserver/wireguard:arm64v8-latest"
    "arm32v7" = "linuxserver/wireguard:arm32v7-latest"
  }
}

variable "wireguard_uid" {
  type        = string
  description = "The UID to be used with Wireguard. Defaults to 1000."
  default     = "1000"

  validation {
    condition     = length(var.wireguard_uid) > 0
    error_message = "Invalid wireguard_uid specified."
  }
}

variable "wireguard_gid" {
  type        = string
  description = "The GID to be used with Wireguard. Defaults to 1000."
  default     = "1000"

  validation {
    condition     = length(var.wireguard_gid) > 0
    error_message = "Invalid wireguard_gid specified."
  }
}

variable "wireguard_peers" {
  type        = string
  description = "Number of peers to create WireGuard configurations for. Defaults to 1."
  default     = "1"

  validation {
    condition     = length(var.wireguard_peers) > 0
    error_message = "Invalid wireguard_peers specified."
  }
}

variable "wireguard_peersdns" {
  type        = string
  description = "DNS server set in peer/client configs. Defaults to 8.8.8.8."
  default     = "8.8.8.8"

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.wireguard_peersdns))
    error_message = "Invalid wireguard_peersdns specified."
  }
}

variable "wireguard_subnet" {
  type        = string
  description = "Internal subnet for the wireguard and server and peers. Defaults to 10.13.13.0."
  default     = "10.13.13.0"

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.wireguard_subnet))
    error_message = "Invalid wireguard_subnet specified."
  }
}
