# Set the required provider and versions
terraform {
  required_providers {
    # We recommend pinning to the specific version of the Docker Provider you're using
    # since new versions are released frequently
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.11.0"
    }
  }
}

# Provider Definition
provider "docker" {
  # uncomment this line to run on a remote host
  #host = "ssh://USERNAME@REMOTE_HOST:REMOTE_PORT"
}
