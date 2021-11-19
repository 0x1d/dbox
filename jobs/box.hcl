job "box" {
  datacenters = ["dc1"]

  group "web" {
    network {
      port "dev" {
        to = 8443
      }
      port "https" {
        to = 443
      }
      port "http" {
        to = 80
      }      
    }

    task "code" {
      driver = "docker"
      config {
        image = "ghcr.io/linuxserver/code-server"
        ports = ["dev"]
      }
      resources {
        cpu    = 1000
        memory = 1024
      }
    }
    task "nextcloud" {
      driver = "docker"
      config {
        image = "ghcr.io/linuxserver/nextcloud:version-22.1.1"
        ports = ["https"]
      }
      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
  
}
