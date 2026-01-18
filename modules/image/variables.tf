variable "node_name" {
  description = "Proxmox node that hosts the datastore used for this artifact."
  type        = string
}

variable "download" {
  description = "Download parameters for the Alpine cloud image."
  type = object({
    datastore_id = optional(string, "local")
    content_type = optional(string, "import")
    url          = optional(string)
    file_name    = optional(string)
  })
  default = {}
}

variable "image" {
  description = "Inputs that drive how the Alpine image URL and filename are synthesized."
  type = object({
    base_url           = optional(string, "https://dl-cdn.alpinelinux.org/alpine")
    release_branch     = optional(string)
    channel            = optional(string, "cloud")
    file_name_prefix   = optional(string, "nocloud_alpine")
    version            = optional(string, "3.23.2")
    platform           = optional(string, "x86_64-uefi-cloudinit-r0")
    artifact_extension = optional(string, "qcow2")
  })
  default = {}
}
