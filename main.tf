terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "node" {
  name = "tradewcs/frontend-internship-proj:latest"
}

resource "docker_container" "node" {
  image = docker_image.node.name
  name  = "node_container_github_actions"

  ports {
    internal = 3000
    external = 3000
  }
}
