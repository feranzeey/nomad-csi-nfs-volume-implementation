job "nginx-nfs" {
  datacenters = ["dc1"]

  group "web" {

    network {
      port "http" {
        static = 8080
      }
    }

    volume "data" {
      type   = "csi"
      source = "nfs-volume"

      attachment_mode = "file-system"
      access_mode     = "single-node-writer"

      read_only = false
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:latest"
        ports = ["http"]
      }

      volume_mount {
        volume      = "data"
        destination = "/usr/share/nginx/html"
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}