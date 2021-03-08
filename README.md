# terraform-wire-hole

This is a collection of Terraform files and configurations to realize a Wireguard-PiHole system, freely editable, to achieve adblocking also for mobile devices outside a network.

List of services:

* Wireguard (VPN)
* NoIP (Dynamic DNS Provider)
* PiHole (AdBlocking)
* CloudFlared (DNS over HTTPS)
* NGINX (Reverse Proxy for PiHole with HTTPS endpoint)

## Requirements

The system can be configured for **amd64, arm32 and arm64** platforms (e.g. RaspBerry Pi 2+, I.MX6+, Rockchip RK3299+, etc.). Terraform will prompt you with the architecture of your choice.

A recent version of Terraform (>=0.13) is recommended, the docker service (18.06+) must be installed on the target platform.

## Run

Before launching the services, a couple of things must be prepared: 

1. Define the variables "DOMAIN_NAME", "DOMAIN_STATE", "DOMAIN_LOCATION", "DOMAIN_ORGANISATION", "DOMAIN_ORGANISATION_UNIT" and "DOMAIN_COUNTRY"
2. The TLS certificates for NGINX must be generated (script in `nginx/config/ssl/` folder)
3. The NoIP configuration file must be generated (script in `noip/` folder)
4. The folders nginx/, noip/, pihole/ must be copied on the target host, in the folder `/infrastructure` and the user must have read/write permissions
5. The entrypoint file `main.tf` should be edited to set eventually a remote host, if the system has to run on it, as follows:

```
provider "docker" {
  host = "ssh://USER@REMOTE_ADDRESS:REMOTE_PORT"
}

```

After these changes, the system can be created as follows:

```
terraform init
terraform plan
terraform apply
```

## Removing the services

To remove everything (networks, volumes, containers), just issue:

```
terraform destroy
```

## Accessing the Services

Without Wireguard activated, the services are accessible within' your host IP Address (e.g. for the PiHole Dashboard, https://REMOTE_ADDRESS/pihole).

With Wireguard activated, the services are accessible with the subnet 10.0.0.0/24 and the PiHole Dashboard with the IP Address 192.168.10.2 (https://192.168.10.2/pihole)

## Caveats / Need Improvement

1. PiHole starts with a random generated password. If you want to change it, execute the following command on the host running the service:

`docker exec -it pihole pihole -a -p` 

or extend the `pihole.tf` with the environment variable **WEBPASSWORD** and specify your password.

2. Input variables can be overridden. At the moment some values contain defaults, they can be changed using [environment variables](https://www.terraform.io/docs/language/values/variables.html).

3. Update of existing services isn't working issue-free when changing some information and applying the terraform plan without destroying the previous one.

4. Paths to be mounted in docker volumes are hardcoded to the path `/infrastructure/SERVICE_NAME/`.