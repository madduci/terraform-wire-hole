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

# if none given, upload is not performed (= local execution)

variable "ssh_user" {
  type = string
  description = "The SSH user name"
  default = ""
}

variable "ssh_port" {
  type = string
  description = "The SSH port"
  default = "22"
}

variable "ssh_private_key" {
  type = string
  description = "The SSH private key"
  default = ""
  sensitive = true
}

variable "ssh_host" {
  type = string
  description = "The SSH host"
  default = ""
}

variable "destination_folder" {
  type = string
  description = "The remote folder where to store the configuration files"
  default = ""
}

# Define the mountpoints as variable 

locals {
  noip_config_folder = var.destination_folder != "" && var.ssh_user != "" ? "/home/${var.ssh_user}/${var.destination_folder}/noip/config" : "${abspath(path.root)}"
  noip_conf = "${local.noip_config_folder}/no-ip2.conf"
}
