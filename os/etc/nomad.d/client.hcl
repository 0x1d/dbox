# /etc/nomad.d/client.hcl

datacenter = "dc1"

# data_dir tends to be environment specific.
data_dir = "/opt/nomad/client/data"

client {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}