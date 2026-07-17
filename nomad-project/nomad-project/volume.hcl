id        = "nfs-volume"
name      = "nfs-volume"

type      = "csi"
plugin_id = "nfs"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}

mount_options {
  fs_type = "nfs"
}

parameters = {
  server = "172.24.240.1"
  share  = "/srv/nomad-storage"
}