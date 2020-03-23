##### This file is required Teraform 0.12 or newer #####

provider "docker" {
  # host = var.docker_host // Use for build outside Docker 
  host = "unix:///var/run/docker.sock" // Use for build inside Docker (dind)
}

##### Docker Images #####
resource "docker_image" "app" {
  name = "app:1.0.0"
}
resource "docker_image" "mongo" {
   name = "mongo:4.2.3"
}

##### Create Private Network #####
resource "docker_network" "private_net" {
    name = "private_net"
    internal = true
    check_duplicate = true
}

resource "docker_network" "public_net" {
    name = "public_net"
    check_duplicate = true
}

##### Create Volume for store data files #####
resource "docker_volume" "db_volume" {
  name = "db_volume"
}

##### MongoDB Provisioning #####
resource "docker_container" "db" {
   image = "${docker_image.mongo.latest}"
   name = "db"
   hostname = "db"
   must_run = true
   restart="always"
   env = ["MONGO_INITDB_ROOT_USERNAME=${var.mongo_usr}",
          "MONGO_INITDB_ROOT_PASSWORD=${var.mongo_pwd}",
          "MONGO_INITDB_DATABASE=${var.mongo_init_db}"]
   command = ["--auth"]
   labels{
     label="env"
     value="${var.env}"
   }
   networks_advanced {
     name="${docker_network.private_net.name}"
   }
   volumes {
       volume_name = "db_volume"
       container_path = "/data/db"
   }

   ports {
       internal = 27017
   }
   healthcheck{
       test=["CMD","mongo","--quiet","db:27017/test", "--eval","'quit(db.runCommand({ping:1}).ok?0:2)'"]
        interval= "10s"
        timeout= "10s"
        retries= 5
        start_period= "40s"
   }
   depends_on = ["docker_network.private_net"]
}

##### NodeJS Provisioning #####
resource "docker_container" "app" {
  image = "${docker_image.app.latest}"
  name = "app"
  hostname = "app"
  must_run = true
  restart="always"
  env = ["MONGODB_ADDON_URI=${var.mongo_uri}", "NODE_ENV=${var.env}"]
  labels {
    label="env"
    value="${var.env}"
  }
  networks_advanced {
     name="${docker_network.private_net.name}"
  }
  networks_advanced {
     name="${docker_network.public_net.name}"
  }
   
  ports {
    internal = 3000
    external = 3000
  }
  healthcheck{
       test=["CMD", "curl", "-f", "http://app:3000/health"]
        interval= "10s"
        timeout= "10s"
        retries= 5
        start_period= "40s"
   }
  depends_on = ["docker_container.db"]
}
