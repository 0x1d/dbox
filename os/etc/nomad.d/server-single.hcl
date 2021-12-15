# /etc/nomad.d/server.hcl

datacenter = "dc1"
data_dir   = "/opt/nomad/server/data"
bind_addr  = "0.0.0.0"

server {
  enabled = true
}
