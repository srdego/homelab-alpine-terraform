resource "proxmox_virtual_environment_vm" "this" {
  # General
  node_name = var.node_name
  vm_id     = var.vm_id

  name        = var.vm_name
  description = var.vm_description

  startup {
    order      = var.startup.order
    up_delay   = var.startup.up_delay
    down_delay = var.startup.down_delay
  }

  tags = sort(distinct(var.vm_tags)) # sort and deduplicate tags to avoid diffs

  # OS
  operating_system {
    type = var.operating_system.type
  }

  # System
  machine = var.machine_type
  bios    = var.bios_type
  efi_disk {
    datastore_id      = var.efi_disk.datastore_id
    file_format       = var.efi_disk.file_format
    type              = var.efi_disk.type
    pre_enrolled_keys = var.efi_disk.pre_enrolled_keys
  }

  agent {
    enabled = var.agent.enabled
    trim    = var.agent.trim
  }

  tpm_state {
    datastore_id = var.tpm_state.datastore_id
    version      = var.tpm_state.version
  }

  # Disks
  scsi_hardware = var.scsi_hardware

  disk {
    import_from  = var.image_file_id
    interface    = var.disk.interface
    datastore_id = var.disk.datastore_id
    size         = var.disk.size
    file_format  = var.disk.file_format
    cache        = var.disk.cache
    discard      = var.disk.discard
    ssd          = var.disk.ssd
  }

  # CPU and Memory
  cpu {
    cores = var.cpu.cores
    type  = var.cpu.type
  }

  memory {
    dedicated = var.memory.dedicated
    floating  = var.memory.floating
  }

  # Network
  network_device {
    bridge = var.network_device.bridge
    model  = var.network_device.model
  }

  # Cloud-init
  initialization {
    datastore_id = var.initialization.datastore_id
    interface    = var.initialization.interface
    file_format  = var.initialization.file_format

    dns {
      domain  = var.dns.domain
      servers = var.dns.servers
    }

    ip_config {
      ipv4 {
        address = var.ipv4.address
        gateway = var.ipv4.gateway
      }
    }

    user_account {
      username = var.user_account.username
      password = var.user_account.password
      keys     = var.user_account.keys
    }
  }
}
