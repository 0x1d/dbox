job "rtmp-stream" {
  datacenters = ["dc1"]

  group "stream" {
    network {
      port "rtmp" {
        to = 1935
      }
    }

    task "nginx-rtmp" {
      driver = "docker"
      config {
        image = "datarhei/nginx-rtmp:1.15.0-dev"
        ports = ["rtmp"]
      }
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
