# ⛰️ Homelab Alpine Terraform - Image Module

Downloads an Alpine nocloud UEFI image once per Proxmox node and exposes the
resulting identifier for VM imports. The module derives the download URL and
filename directly from the inputs you provide (version, branch, platform, etc.).

## 🔍 Notable defaults

- `image.version` feeds the file naming logic. The module strips a leading `v`
  if present and automatically derives the `release_branch` (e.g. `3.23.2`
  becomes `v3.23`).
- `image.file_name_prefix` defaults to `nocloud_alpine`, so the synthesized file
  matches the upstream nocloud artifact naming convention.
- `image.base_url` defaults to `https://dl-cdn.alpinelinux.org/alpine`. Combine
  it with `image.channel` (default `cloud`) and the derived branch to obtain the
  canonical download path stored in Proxmox.
- `download.content_type = "import"` keeps the blob uncompressed, which means
  consumers should use `disk.import_from` (see the VM module example below).
- Optional overrides (`download.url`, `download.file_name`) let you point at a
  custom mirror or precomputed artifact name when necessary.

## 🚀 Example usage

```hcl
module "alpine_image" {
  source    = "./modules/image"
  node_name = "bm-01"
  image = {
    version  = "3.23.2"
    platform = "x86_64-uefi-cloudinit-r0"
  }
}

module "alpine_vm" {
  source        = "./modules/vm"
  node_name     = "bm-01"
  vm_id         = 300
  vm_name       = "alpine-01"
  image_file_id = module.alpine_image.file_id
  # ...
}
```

Refer to the provider documentation for more details on the
[`proxmox_virtual_environment_download_file`][proxmoxDownloadFileDefinition]
resource.

[proxmoxDownloadFileDefinition]: https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file
