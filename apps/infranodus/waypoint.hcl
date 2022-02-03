app "infranodus" {
    build {
        use "pack" {
            builder="gcr.io/buildpacks/builder:v1"
        }
    }
    deploy {
        use "docker" {}
    }
}
