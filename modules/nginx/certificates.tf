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
