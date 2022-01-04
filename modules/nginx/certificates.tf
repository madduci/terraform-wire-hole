resource "null_resource" "nginx_certs" {
  provisioner "local-exec" {
    working_dir = "${abspath(path.module)}/config/ssl/"
    command     = "./generate-certs.sh"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      DOMAIN_NAME = var.domain_name
      DOMAIN_C    = var.domain_country
      DOMAIN_ST   = var.domain_state
      DOMAIN_L    = var.domain_location
      DOMAIN_O    = var.domain_organisation
      DOMAIN_OU   = var.domain_organisation_unit
      DOMAIN_N    = var.domain_common_name
    }
  }
}

resource "null_resource" "generated_certs" {

  connection {    
    type     = "ssh"   
    user     = var.ssh_user 
    private_key = "${file(var.ssh_private_key)}"    
    host     = var.ssh_host 
    port = var.ssh_port
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/${var.destination_folder}/nginx"
    ]
  }

  provisioner "file" {
    source = "${abspath(path.module)}/config"
    destination = "/home/${var.ssh_user}/${var.destination_folder}/nginx/"    
  }

  depends_on = [ null_resource.nginx_certs ]
  count = var.ssh_user != "" && var.destination_folder != "" ? 1 : 0
}
