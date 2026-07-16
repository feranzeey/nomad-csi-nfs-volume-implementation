job "nfs-csi-plugin" {
  datacenters = ["dc1"]
  type = "system"

  group "plugin" {

    task "plugin" {
      driver = "docker"

      config {
        image = "mcr.microsoft.com/k8s/csi/nfs-csi:v4.8.0"
        privileged = true

        args = [
          "--endpoint=unix:///csi/csi.sock",
          "--nodeid=${node.unique.id}",
          "--drivername=nfs.csi.k8s.io"
        ]
      }

      csi_plugin {
        id        = "nfs"
        type      = "monolith"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 200
        memory = 256
      }

      env {
        CSI_ENDPOINT = "unix:///csi/csi.sock"
      }
    }
  }
}