# Docker Vault

This Docker Vault container is using [Busybox](https://registry.hub.docker.com/u/progrium/busybox/) and [Hashicorp's Vault](https://vaultproject.io/).

Vault uses TCP/8200 by default, so we'll keep that. The demo configuration is listening on all interfaces (not just localhost), and using demo.consul.io as per the [getting started docs](https://vaultproject.io/intro/getting-started/deploy.html).

Configuration is stored under `config/`.

The automated latest build is always available at [sjourdan/vault](https://registry.hub.docker.com/u/sjourdan/vault/):

    $ docker pull sjourdan/vault

## Vault Server

As per [Issue 59](https://github.com/hashicorp/vault/issues/59), need to add `--cap-add IPC_LOCK` option.

Start by default in **dev mode**:

    $ docker run -t -i \
      --cap-add IPC_LOCK \
      -p 8200:8200 \
      --hostname vault \
      --name vault sjourdan/vault

Start with a **demo Consul backend** using [demo.consul.io](https://demo.consul.io):

    $ docker run -t -i \
      --cap-add IPC_LOCK \
      -p 8200:8200 \
      --hostname vault \
      --name vault \
      --volume $PWD/config:/config \
      sjourdan/vault -config=/config/demo.hcl


To initialize Vault, on your workstation with `vault` installed:

    $ export VAULT_ADDR='http://a.b.c.d:8200'
    $ vault init

Then [RTFM](https://vaultproject.io/intro/getting-started/first-secret.html) for Vault usage.

## Consul

I'm using Progrium's Consul Docker box, it's working great.
Here's with the WebUI:

    $ docker run -p 8400:8400 -p 8500:8500 -p 8600:53/udp --hostname consul --name consul progrium/consul -server -bootstrap -ui-dir /ui

The [WebGUI](http://a.b.c.d:8500/) should be available.
