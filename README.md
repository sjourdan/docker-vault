# Docker Vault

[![Circle CI](https://circleci.com/gh/sjourdan/docker-vault.svg?style=shield)](https://circleci.com/gh/sjourdan/docker-vault)

For the quickest setup possible

1. Run vault.sh
2. Download vault and run ./vault init

Note: A directory called Vault will be created in your root directory

This Docker Vault container is using [Alpine Linux](https://hub.docker.com/_/alpine/) minimal image and [Hashicorp's Vault](https://vaultproject.io/).

Vault uses TCP/8200 by default, so we'll keep that. The demo configuration is listening on all interfaces (not just localhost), and using demo.consul.io as per the [getting started docs](https://vaultproject.io/intro/getting-started/deploy.html).

Configuration examples are stored under `config/` in the git working directory.

The automated latest build is always available at [sjourdan/vault](https://registry.hub.docker.com/u/sjourdan/vault/):

`docker pull sjourdan/vault`

## Vault Server

### Dev mode

Start vault server in a **dev mode**:

```
docker run -d \
      -p 8200:8200 \
      --hostname vault \
      --name vault sjourdan/vault
```

### Using the Demo Consul Backend

Start with a **demo Consul backend** using [demo.consul.io](https://demo.consul.io):

```
docker run -d \
      -p 8200:8200 \
      --hostname vault \
      --name vault \
      --volume $PWD/config:/config \
      sjourdan/vault server -config=/config/demo.hcl
```

### Using your own Consul backend

### Consul

For this purpose you can use [Progrium's Consul Docker box](https://github.com/gliderlabs/docker-consul) container, it's working great. If you have a running Consul container named `consul` you can skip the step bellow:

```
# Starting consul container with web ui on port 8500
docker run -p 8400:8400 -p 8500:8500 -p 8600:53/udp --hostname consul --name consul progrium/consul -server -bootstrap -ui-dir /ui
```

When your consul service is started and accessible via links or DNS as consul, you can just start vault server using the following command:

```
docker run -d \
      -p 8200:8200 \
      --hostname vault \
      --name vault \
      --link consul:consul \
      --volume $PWD/config:/config \
      sjourdan/vault server -config=/config/consul.hcl
```

## Using Vault

To initialize Vault, on your workstation with `vault` installed, first we need to export vault ip address. If you bootstrapped containers on your machine you can use  `docker inspect -f '{{ .NetworkSettings.IPAddress }}' vault` command to get the vault container internal ip address.

```
# The address must start with protocol specifier!
export VAULT_ADDR='http://a.b.c.d:8200'
```

And refer to [vault documentation](https://www.vaultproject.io/docs/index.html) on how to initialize and unseal data store. In case if you are evaluating in **dev mode** of vault server, the empty initialized and unsealed **inmem** vault data store will be automatically created.

You can simply export the root token printed on vault server startup as `export VAULT_TOKEN=PASTE_YOUR_TOKEN_HERE`.

To use a vault client from a container you can create a wrapper function like below:

```
vault () { docker run -it --rm -e VAULT_ADDR --entrypoint=/bin/sh sjourdan/vault -c "vault auth $VAULT_TOKEN &>/dev/null; vault $*" }
```

The above invocation method of course could directly path-through `$VAULT_TOKEN` using docker `-e` option, however we don't want to re-define this environment variable, so we emulate auth session and only after pass arguments to vault.

Also you can use alias, but this overrides `$VAULT_TOKEN` and **is not recommend**, since it affects vault client default usage scenario.

```
alias vault="docker run --rm -e VAULT_ADDR -e VAULT_TOKEN sjourdan/vault"
```
