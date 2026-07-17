data_dir = "/tmp/nomad"

bind_addr = "0.0.0.0"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true

  options = {
    "docker.privileged.enabled" = "true"
  }
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}