# /etc/nomad.d/server.hcl

datacenter = "yaktown"
data_dir   = "/opt/nomad/server/data"
bind_addr  = "0.0.0.0"

server {
  enabled          = true
  bootstrap_expect = 3
  server_join {
    retry_join = ["<known-address>:4648"]
  }
}
