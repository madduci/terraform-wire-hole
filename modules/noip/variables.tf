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
  description = "The Docker Image name to download. Defaults to romeupalos/noip:latest"
  default     = "romeupalos/noip:latest"
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

variable "public_network" {
  type        = string
  description = "The name of the docker public network"
  validation {
    condition     = length(var.public_network) > 4
    error_message = "The public_network value must be a defined."
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

# Define the mountpoints as variable 

locals {
  noip_conf = "${abspath(path.module)}/config/no-ip2.conf"
}
