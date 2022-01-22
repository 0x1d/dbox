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
    release {
        use "docker"
    }
}
