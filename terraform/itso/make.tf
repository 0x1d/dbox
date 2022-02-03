resource "null_resource" "itso" {
  provisioner "local-exec" {
    command = "./ctl.sh info"
    working_dir = "/dbox"
    interpreter = ["bash", "-c"]
  }
}
