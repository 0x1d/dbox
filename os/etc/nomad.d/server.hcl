# /etc/nomad.d/server.hcl

# data_dir tends to be environment specific.
data_dir = "/opt/nomad/server/data"

server {
  enabled          = true
  bootstrap_expect = 1
}
