job "nginx" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {

    network {
      port "http" {
        to = 80
      }
    }

    volume "shared-volume" {
      type            = "csi"
      source          = "nfs-volume"
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
      read_only       = false
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:latest"
        ports = ["http"]
      }

      volume_mount {
        volume      = "shared-volume"
        destination = "/usr/share/nginx/html"
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}