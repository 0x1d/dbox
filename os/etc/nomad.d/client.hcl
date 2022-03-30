# /etc/nomad.d/client.hcl

datacenter = "dc1"
data_dir   = "/opt/nomad/client/data"
bind_addr  = "0.0.0.0"

client {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
