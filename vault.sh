#!/bin/bash
mkdir ~/Vault
git clone https://github.com/sjourdan/docker-vault ~/Vault
docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp --hostname consul --name consul progrium/consul -server -bootstrap -ui-dir /ui
docker run -d \
     -p 8200:8200 \
     --hostname vault \
     --name vault \
     --link consul:consul \
     --volume ~/Vault/config:/config \
     sjourdan/vault server -config=/config/consul.hcl
export VAULT_ADDR="http://127.0.0.1:8200"
echo "Now download Vault and run './vault init'"
