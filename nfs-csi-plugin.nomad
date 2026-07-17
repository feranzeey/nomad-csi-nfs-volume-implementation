job "nfs-csi-plugin" {
  datacenters = ["dc1"]
  type = "system"

  group "plugin" {

    restart {
      attempts = 5
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    task "plugin" {
      driver = "docker"

      config {
        image      = "mcr.microsoft.com/k8s/csi/nfs-csi:v4.8.0"
        privileged = true

        args = [
            "-v=5",
            "--endpoint=unix:///csi/csi.sock",
            "--nodeid=${node.unique.name}",

        ]
      }

      csi_plugin {
        id        = "nfs"
        type      = "monolith"
        mount_dir = "/csi"
      }

      env {
        CSI_ENDPOINT = "unix:///csi/csi.sock"
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}