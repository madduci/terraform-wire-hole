#!/usr/bin/env bash

set -eou pipefail

export DOMAIN_C=${DOMAIN_COUNTRY:-DE}
export DOMAIN_ST=${DOMAIN_STATE:-Berlin}
export DOMAIN_L=${DOMAIN_LOCATION:-Berlin}
export DOMAIN_O=${DOMAIN_ORGANISATION:-"Michele Adduci"}
export DOMAIN_OU=${DOMAIN_ORGANISATION_UNIT:-myself}
export DOMAIN_N=${DOMAIN_NAME}

cat server_cert.conf.template | envsubst > server_cert.conf

openssl ecparam -genkey -name secp384r1 -out key.pem
openssl req -new -sha256 -key key.pem -out csr.csr -config server_cert.conf
openssl req -x509 -sha256 -days 365 -key key.pem -in csr.csr -out certificate.pem
openssl req -in csr.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well" || echo "This certificate will stop working in 2022! You must update OpenSSL to generate a widely-compatible certificate"
openssl dhparam -out dhparam-2048.pem 2048

