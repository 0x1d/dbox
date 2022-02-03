resource "null_resource" "itso" {
  provisioner "local-exec" {
    command = "make install-docker"
   # working_dir = "/waypoint"
    interpreter = ["bash", "-c"]
  }
}
