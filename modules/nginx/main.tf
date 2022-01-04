# Set the required providers and versions

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }

    null = {
      version = "3.1.0"
    }

    local = {
      version = "2.1.0"
    }
  }
}

# Provider Definitions

provider "docker" {
  host = var.docker_host
}