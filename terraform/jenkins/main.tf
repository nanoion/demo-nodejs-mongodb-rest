##### Required Teraform 0.12 or newer #####
provider "docker" {
  host = var.docker_host
}

variable "docker_host" {
    default = "tcp://127.0.0.1:2375"
}

variable "env" {
    type = string
    default = "dev"
}

##### Docker Images #####
resource "docker_image" "jenkins" {
  name = "jenkins:dind"
}

resource "docker_volume" "jenkins" {
  name = "jenkins"
}

resource "docker_container" "jenkins" {
   image = "${docker_image.jenkins.latest}"
   name = "jenkins"
   hostname = "jenkins"
   must_run = true
   privileged=true

   labels{
     label="env"
     value="${var.env}"
   }

   volumes {
       volume_name = "jenkins"
       container_path = "/var/jenkins_home"
   }

    volumes {
       volume_name = "/var/run/docker.sock"
       container_path = "/var/run/docker.sock"
   }
    
   ports {
       internal = 50000
       external = 50000
   }
   ports {
       internal = 8080
       external = 8080
   }
   
}