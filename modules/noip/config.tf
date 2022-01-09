# Optionally upload configuration to the remote host, if ssh_user and destination_folder are supplied
resource "null_resource" "remote_upload_config" {

  connection {    
    type     = "ssh"   
    user     = var.ssh_user 
    private_key = "${file(var.ssh_private_key)}"    
    host     = var.ssh_host 
    port = var.ssh_port
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/${var.destination_folder}/noip/config"
    ]
  }

  provisioner "file" {
    source = "${abspath(path.root)}/no-ip2.conf"
    destination = "/home/${var.ssh_user}/${var.destination_folder}/noip/config/no-ip2.conf"    
  }

  count = var.ssh_user != "" && var.destination_folder != "" ? 1 : 0
}
