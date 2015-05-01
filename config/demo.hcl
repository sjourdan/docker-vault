backend "consul" {
  address = "demo.consul.io:80"
  path = "demo_vault_changeme"
  advertise_addr = "127.0.0.1"
}

listener "tcp" {
 address = "0.0.0.0:8200"
 tls_disable = 1
}
