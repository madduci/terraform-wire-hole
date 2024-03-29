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
  description = "The Docker Image name to download. Defaults to nginx:alpine"
  default     = "nginx:alpine"
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

# if none given, upload is not performed (= local execution)

variable "ssh_user" {
  type        = string
  description = "The SSH user name"
  default     = ""
}

variable "ssh_port" {
  type        = string
  description = "The SSH port"
  default     = "22"
}

variable "ssh_private_key" {
  type        = string
  description = "The SSH private key"
  default     = ""
  sensitive   = true
}

variable "ssh_host" {
  type        = string
  description = "The SSH host"
  default     = ""
}

variable "destination_folder" {
  type        = string
  description = "The remote folder where to store the configuration files"
  default     = ""
}

# Define local variables to be used for mountpoints
locals {
  nginx_config_folder   = var.destination_folder != "" && var.ssh_user != "" ? "/home/${var.ssh_user}/${var.destination_folder}/nginx/config" : "${abspath(path.module)}/config"
  nginx_default_conf    = "${local.nginx_config_folder}/templates/default.conf"
  nginx_proxy_conf      = "${local.nginx_config_folder}/templates/proxy.conf"
  nginx_server_dhparams = "${local.nginx_config_folder}/ssl/dhparam-2048.pem"
  nginx_server_cert     = "${local.nginx_config_folder}/ssl/certificate.pem"
  nginx_server_key      = "${local.nginx_config_folder}/ssl/key.pem"
  nginx_webroot_folder  = "${local.nginx_config_folder}/webroot"
}
