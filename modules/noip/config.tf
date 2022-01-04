resource "null_resource" "noip_config" {
  provisioner "local-exec" {
    working_dir = "${abspath(path.module)}"
    command     = "mkdir -p config && cp -v ${abspath(path.root)}/no-ip2.conf ${abspath(path.module)}/config/no-ip2.conf"
    interpreter = ["/bin/bash", "-c"]
  }
}
