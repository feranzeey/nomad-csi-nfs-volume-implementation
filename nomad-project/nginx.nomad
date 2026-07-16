job "nginx-nfs" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {

    network {
      port "http" {
        static = 8080
      }
    }

    volume "data" {
      type            = "csi"
      source          = "nfs-volume"
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
      read_only       = false
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
        read_only   = false
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}