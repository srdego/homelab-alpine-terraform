output "id" {
  value = proxmox_virtual_environment_vm.this.id
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "node_name" {
  value = proxmox_virtual_environment_vm.this.node_name
}

output "qemu_guest_agent" {
  value = proxmox_virtual_environment_vm.this.agent
}
