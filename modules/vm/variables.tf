# General
variable "node_name" {
  description = "Proxmox compute node (e.g. bm-01) where this VM will be created."
  type        = string
}

variable "vm_id" {
  description = "Stable VMID inside Proxmox; must be unique per cluster."
  type        = number
}

variable "vm_name" {
  description = "Visible VM name/hostname shown in the Proxmox UI."
  type        = string
}

variable "vm_description" {
  description = "Description text surfaced in Proxmox; defaults to a generic note."
  type        = string
  default     = "Managed by Terraform."
}

variable "startup" {
  description = <<-EOT
    Optional startup ordering and delays (seconds) applied when Proxmox boots
    or stops the VM.
  EOT
  type = object({
    order      = optional(number, 1)
    up_delay   = optional(number, -1)
    down_delay = optional(number, -1)
  })
  default = {}
}

variable "vm_tags" {
  description = <<-EOT
    Tags assigned to the VM; the resource sorts/deduplicates before sending
    to Proxmox, as it expects sorted tags and will report diffs otherwise.
  EOT
  type        = list(string)
  default     = []
}

# OS
variable "operating_system" {
  description = "Guest OS hints."
  type = object({
    type = optional(string, "l26") # linux 2.6-6.x kernel
  })
  default = {}
}

# System
variable "machine_type" {
  description = "QEMU machine type (q35 for UEFI)."
  type        = string
  default     = "q35"
}

variable "bios_type" {
  description = "Firmware/BIOS type (ovmf required for UEFI)."
  type        = string
  default     = "ovmf"
}

variable "efi_disk" {
  description = <<-EOT
    EFI vars disk settings; keep pre_enrolled_keys=false so images boots under
    secure boot.
  EOT
  type = object({
    datastore_id      = optional(string, "local-lvm")
    file_format       = optional(string, "raw")
    type              = optional(string, "4m")
    pre_enrolled_keys = optional(bool, false)
  })
  default = {}
}

variable "agent" {
  description = <<-EOT
    QEMU guest agent toggles; Images needs to install qemu-guest-agent package
    for these to work correctly; trim=true enables SSD optimizations.
  EOT
  type = object({
    enabled = optional(bool, true)
    trim    = optional(bool, true)
  })
  default = {}
}

variable "tpm_state" {
  description = "Backing datastore/version for the emulated TPM."
  type = object({
    datastore_id = optional(string, "local-lvm")
    version      = optional(string, "v2.0")
  })
  default = {}
}

# Disks
variable "scsi_hardware" {
  description = "VirtIO SCSI controller choice."
  type        = string
  default     = "virtio-scsi-pci"
}

variable "image_file_id" {
  description = <<-EOT
    ID returned by proxmox_virtual_environment_download_file for the disk image.
    Pass this directly to the disk.import_from argument because the Alpine
    image stays uncompressed (content_type = "import").
  EOT
  type        = string
}

variable "disk" {
  description = <<-EOT
    Root disk parameters (size in GiB, datastore, cache policy, etc.).
    Size is expressed in GiB; discard="on" enables TRIM support;
    ssd=true enables SSD optimizations.
  EOT
  type = object({
    interface    = optional(string, "scsi0")
    datastore_id = optional(string, "local-lvm")
    size         = optional(number, 10) # in GiB
    file_format  = optional(string, "raw")
    cache        = optional(string, "writethrough")
    discard      = optional(string, "on") # enables TRIM support
    ssd          = optional(bool, true)   # enables SSD optimizations
  })
  default = {}
}

# CPU and Memory
variable "cpu" {
  description = <<-EOT
    vCPU topology overrides; type="host" enables advanced CPU features for better
    performance but prevents live migration. Change to "x86-64-v2-AES" if needed.
  EOT
  type = object({
    cores = optional(number, 2)
    type  = optional(string, "host")
  })
  default = {}
}

variable "memory" {
  description = <<-EOT
    Memory reservation is expressed in MiB. I like to disable ballooning, so
    floating=0 by default.
  EOT
  type = object({
    dedicated = optional(number, 2048) # in MiB
    floating  = optional(number, 0)
  })
  default = {}
}

# Network
variable "network_device" {
  description = "Primary NIC settings (bridge/model); defaults target virtio on vmbr0."
  type = object({
    bridge = optional(string, "vmbr0")
    model  = optional(string, "virtio")
  })
  default = {}
}

# Cloud-init
variable "initialization" {
  description = "Cloud-init seed disk placement."
  type = object({
    datastore_id = optional(string, "local-lvm")
    interface    = optional(string, "ide0")
    file_format  = optional(string, "raw")
  })
  default = {}
}

variable "dns" {
  description = "Cloud-init DNS domain + resolvers."
  type = object({
    domain  = string
    servers = list(string)
  })
}

variable "ipv4" {
  description = "Cloud-init static IPv4/CIDR and gateway."
  type = object({
    address = string
    gateway = string
  })
}

variable "user_account" {
  description = <<-EOT
    Cloud-init user account: username, password, and SSH public keys.
    At least one user_account must be provided to create a non-default user.
  EOT
  type = object({
    username = string
    password = string
    keys     = list(string)
  })
  default = {}
}
