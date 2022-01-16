# Optionally creates the destination folder to the remote host, if ssh_user and destination_folder are supplied
resource "null_resource" "create_destination_folder" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key)
    host        = var.ssh_host
    port        = var.ssh_port
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/${var.destination_folder}"
    ]
  }

  count      = var.ssh_user != "" && var.destination_folder != "" ? 1 : 0
}
