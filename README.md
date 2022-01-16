# terraform-wire-hole

This is a collection of Terraform files and configurations to configure automatically a Wireguard-PiHole system, freely editable, to achieve adblocking also for mobile devices outside a home network.

List of services included in this project:

* Wireguard (VPN)
* NoIP (Dynamic DNS Provider)
* PiHole (AdBlocking)
* CloudFlared (DNS over HTTPS)
* NGINX (Reverse Proxy for PiHole with HTTPS endpoint)

The Services are all optional. It means that you can decide what you'd like to run by commenting out the unneeded Modules in the `main.tf` file in the root folder.

## Requirements

The system can be configured for **amd64, arm32 and arm64** platforms (e.g. RaspBerry Pi 2+, I.MX6+, Rockchip RK3299+, etc.). Terraform will prompt you with the architecture of your choice.

A recent version of Terraform (>=0.13) is recommended, the docker service (18.06+) must be installed on the target platform.

## Run

Before invoking Terraform and setup the services, a couple of things must be prepared: 

1. Define a `tfvars` file with all the required variables
2. The NoIP configuration file must be generated with the provided Bash Script (`noip.sh`), if you plan to use NoIP.

After these changes, the system can be created as follows:

```
terraform init
terraform plan -var-file=settings.tfvars
terraform apply -var-file=local.tfvars
```

## Removing the services

To remove everything (networks, volumes, containers), you need to invoke the following command:

```
terraform destroy -var-file=local.tfvars
```

## Accessing the Services

Without Wireguard activated, the services are accessible within' your host IP Address (e.g. for the PiHole Dashboard, https://REMOTE_ADDRESS/pihole).

With Wireguard activated, the PiHole Dashboard will be available at the IP Address 192.168.10.2 (https://192.168.10.2/pihole or https://REMOTE_IP/pihole, in case of remote deployment).

## Caveats / Need Improvement

1. Images aren't updated automatically with the digest trigger, if they are kept locally after the destroy. This stictly depends on the provider.

2. Input variables can be overridden. At the moment some values contain default values, they can be changed using [environment variables](https://www.terraform.io/docs/language/values/variables.html) or [Variable Definition](https://www.terraform.io/language/values/variables#variable-definitions-tfvars-files) files.

3. Update of existing services isn't working issue-free when changing some information. It could be necessary to destroy the environment first and apply again the setup.

4. It's possible that some names (docker containers, docker networks, docker volumes) or IPv4 Ranges might exist or be reserved/in use on your Docker Host, therefore applying this Terraform setup might result in an error, due to name-clashes. Please edit the necessary files (`variables.tf`, `network.tf`) and adjust them according to your needs.

5. Remote configuration doesn't support nested remote destination folders. The only destination folder required for uploading files (nginx SSL certs, noip config) must be at root level, in the current SSH user folder (e.g. if the remote SSH user is 'vagrant', the folder will be created as `/home/vagrant/folder`).

6. Doing changes to Docker Networks implies a full `terrarorm destroy`, since the services (the Docker Containers) are strictly depending from them.

7. Uploading resources to a remote host requires a SSH Identity which isn't password protected, since the [File function](https://www.terraform.io/language/functions/file) isn't able to read password-protected files.

8. If you change the docker network subnets (e.g. because of conflicts) and the assigned IP to services in the `variables.tf` file, you'll need to check that the `nginx/templates/default.conf` file has the correct PiHole IP Address stored.