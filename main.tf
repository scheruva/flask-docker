terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

variable "artifactory_url" { type = string }
variable "artifactory_user" { type = string }
variable "artifactory_password" { type = string, sensitive = true }

provider "docker" {
  registry_auth {
    address  = var.artifactory_url
    username = var.artifactory_user
    password = var.artifactory_password
  }
}

# Build and Push Combined Flask + Nginx Image to Artifactory
resource "docker_registry_image" "flask_nginx_app" {
  name = "${var.artifactory_url}/flask-nginx-app:latest"

  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}
