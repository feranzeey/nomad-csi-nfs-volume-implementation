id        = "nfs-volume"
name      = "nfs-volume"

type      = "csi"
plugin_id = "nfs"

capability {
  access_mode     = "multi-node-multi-writer"
  attachment_mode = "file-system"
}

mount_options {
  fs_type = "nfs"
}

parameters = {
  server = "172.17.5.59"
  share  = "/srv/nomad-storage"
}