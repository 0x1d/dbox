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
      env {
        PUID = 1000
        PGID = 1000
        TZ = Europe/Zurich
      }
      config {
        image = "ghcr.io/linuxserver/code-server:3.12.0"
        ports = ["dev"]
      }
      resources {
        cpu    = 1000
        memory = 1024
      }
    }
    task "syncthing" {
      driver = "docker"
      env {
        PUID = 1000
        PGID = 1000
        TZ = Europe/Zurich
      }
      config {
        image = "ghcr.io/linuxserver/syncthing:1.18.5"
        ports = ["https"]
      }
      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
  
}

    volumes:
      - /path/to/appdata/config:/config
      - /path/to/data1:/data1
      - /path/to/data2:/data2
    ports:
      - 8384:8384
      - 22000:22000/tcp
      - 22000:22000/udp
      - 21027:21027/udp