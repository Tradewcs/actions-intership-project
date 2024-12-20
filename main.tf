terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}

provider "docker" {}

variable "dockerhub_username" {
  type        = string
  description = "DockerHub Username"
  default     = ""
}

variable "dockerhub_password" {
  type        = string
  description = "DockerHub Password"
  sensitive   = true
  default     = ""
}

variable "image_name_frontend" {
  type        = string
  description = "Frontend Docker image name"
  default     = "tradewcs/frontend-internship-proj"
}

variable "image_name_gradle" {
  type        = string
  description = "Gradle Docker image name"
  default     = "tradewcs/gradle-internship-proj"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
  default     = "latest"
}

resource "null_resource" "docker_login" {
  provisioner "local-exec" {
    command = <<-EOT
      docker login -u "${var.dockerhub_username}" -p "${var.dockerhub_password}"
    EOT
  }
}

resource "null_resource" "docker_build_push_frontend" {
  depends_on = [null_resource.docker_login]

  provisioner "local-exec" {
    command = <<-EOT
      docker build -f Dockerfile-frontend -t ${var.dockerhub_username}/${var.image_name_frontend}:${var.image_tag} .
      docker push ${var.dockerhub_username}/${var.image_name_frontend}:${var.image_tag}
    EOT
  }
}

resource "null_resource" "docker_build_push_gradle" {
  depends_on = [null_resource.docker_login]

  provisioner "local-exec" {
    command = <<-EOT
      docker build -f Dockerfile-gradle -t ${var.dockerhub_username}/${var.image_name_gradle}:${var.image_tag} .
      docker push ${var.dockerhub_username}/${var.image_name_gradle}:${var.image_tag}
    EOT
  }
}
