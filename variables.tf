variable "DOMAIN_NAME" {
  type        = string
  description = "The domain name used for Wireguard configuration"
  default     = "wackenberg.ddns.net"
  validation {
    condition     = length(var.DOMAIN_NAME) > 4
    error_message = "The DOMAIN_NAME value must be a valid domain name."
  }
}

variable "ARCHITECTURE" {
  type        = string
  description = "The target host architecture. Valid values are: amd64, arm64v8, or arm32v7."

  validation {
    condition     = contains(["amd64", "arm64v8", "arm32v7"], var.ARCHITECTURE)
    error_message = "Invalid ARCHITECTURE specified. Valid values are: amd64, arm64v8, or arm32v7."
  } 
}

variable "TIME_ZONE" {
  type = string
  description = "The timezone to be used (default: Europe/Berlin)"
  default = "Europe/Berlin"

  validation {
    condition     = length(var.TIME_ZONE) > 0
    error_message = "Invalid TIME_ZONE specified."
  } 
}

variable "WIREGUARD_UID" {
  type = string
  description = "The UID to be used with Wireguard (default: 1000)"
  default = "1000"

  validation {
    condition     = length(var.WIREGUARD_UID) > 0
    error_message = "Invalid WIREGUARD_UID specified."
  } 
}

variable "WIREGUARD_GID" {
  type = string
  description = "The GID to be used with Wireguard (default: 1000)"
  default = "1000"

  validation {
    condition     = length(var.WIREGUARD_GID) > 0
    error_message = "Invalid WIREGUARD_GID specified."
  } 
}

variable "WIREGUARD_PEERS" {
  type = string
  description = "The maximum clients to be used with Wireguard (default: 5)"
  default = "5"

  validation {
    condition     = length(var.WIREGUARD_PEERS) > 0
    error_message = "Invalid WIREGUARD_PEERS specified."
  } 
}

variable "WIREGUARD_SUBNET" {
  type = string
  description = "The subnet to be used for Wireguard clients (default: 10.1.0.0)"
  default = "10.1.0.0"

  validation {
    condition     = length(var.WIREGUARD_SUBNET) > 0
    error_message = "Invalid WIREGUARD_SUBNET specified."
  }
}