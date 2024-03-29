variable "docker_host" {
  type        = string
  description = "The Path to local unix docker socket or a remote SSH connection string to a host where docker is running"
  validation {
    condition     = can(regex("^[unix|ssh].*$", var.docker_host))
    error_message = "The docker_host value must be set. Allowed strings are in format 'unix:///var/run/docker.sock' or 'ssh://USERNAME@REMOTE_HOST:REMOTE_PORT'."
  }
}

variable "image_name" {
  type        = string
  description = "The Docker Image name to download. Defaults to linuxserver/wireguard:amd64-latest"
  default     = "linuxserver/wireguard:amd64-latest"
  validation {
    condition     = length(var.image_name) > 0
    error_message = "The image_name value must be set."
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

variable "domain_name" {
  type        = string
  description = "The domain name used for the configuration"
  validation {
    condition     = length(var.domain_name) > 4
    error_message = "The domain_name value must be a valid domain name."
  }
}

variable "public_network" {
  type        = string
  description = "The name of the docker public network"
  validation {
    condition     = length(var.public_network) > 4
    error_message = "The public_network value must be a defined."
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

variable "public_address" {
  type        = string
  description = "The IPv4 Address of the service, facing the public network"
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.public_address))
    error_message = "The public_address value must be a defined."
  }
}

variable "service_address" {
  type        = string
  description = "The IPv4 Address of the service, facing the service network"
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.service_address))
    error_message = "The service_address value must be a defined."
  }
}

variable "dns_server_address" {
  type        = string
  description = "DNS server set in peer/client configs. Defaults to 8.8.8.8."
  default     = "8.8.8.8"

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.dns_server_address))
    error_message = "The dns_server_address value must be a defined."
  }
}

# Specific WireGuard settings
variable "uid" {
  type        = string
  description = "The UID to be used with Wireguard (default: 1000)"
  default     = "1000"

  validation {
    condition     = length(var.uid) > 0
    error_message = "Invalid uid specified."
  }
}

variable "gid" {
  type        = string
  description = "The GID to be used with Wireguard (default: 1000)"
  default     = "1000"

  validation {
    condition     = length(var.gid) > 0
    error_message = "Invalid gid specified."
  }
}

variable "peers" {
  type        = string
  description = "The maximum clients to be used with Wireguard (default: 5)"
  default     = "5"

  validation {
    condition     = length(var.peers) > 0
    error_message = "Invalid number of peers specified."
  }
}

variable "subnet" {
  type        = string
  description = "Internal subnet for the wireguard and server and peers. Defaults to 10.13.13.0."
  default     = "10.13.13.0"

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.subnet))
    error_message = "Invalid subnet specified."
  }
}

variable "ssh_user" {
  type        = string
  description = "The SSH user name"
  default     = ""
}

variable "destination_folder" {
  type        = string
  description = "The remote folder where to store the configuration files"
  default     = ""
}

# Define local variables

locals {
  wireguard_config_folder  = var.destination_folder != "" && var.ssh_user != "" ? "/home/${var.ssh_user}/${var.destination_folder}/wireguard/config" : "${abspath(path.module)}/config"
  wireguard_modules_folder = "/lib/modules"
}
