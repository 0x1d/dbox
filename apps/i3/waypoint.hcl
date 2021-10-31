# The name of your project. A project typically maps 1:1 to a VCS repository.
# This name must be unique for your Waypoint server. If you're running in
# local mode, this must be unique to your machine.
project = "dbox"
labels = { "base" = "arch-i3" }

app "i3" {
    build {
        use "docker" {}
        registry {
          use "docker" {
            image = "wirelos/i3"
            tag   = "latest"
            local = true
          }
        }
    }
    deploy {
        use "docker" {}
    }
}
