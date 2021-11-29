server {
  enabled          = true
  bootstrap_expect = 3

  # This is the IP address of the first server provisioned
  server_join {
    retry_join = ["<known-address>:4648"]
  }
}
