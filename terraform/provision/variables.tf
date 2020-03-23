variable "docker_host" {
    default = "tcp://127.0.0.1:2375"
}

variable "env" {
    type = string
    default = "production"
}

variable "mongo_uri" {
    type = string
    default = "mongodb://admin:welcome1@db:27017/test?authSource=admin"
}

variable "mongo_usr" {
    type = string
    default = "admin"
}

variable "mongo_pwd" {
    type = string
    default = "welcome1"
}

variable "mongo_init_db" {
    type = string
    default = "welcome1"
}