output "file_id" {
  description = "Identifier of the downloaded artifact (compatible with disk import_from)."
  value       = proxmox_virtual_environment_download_file.this.id
}
