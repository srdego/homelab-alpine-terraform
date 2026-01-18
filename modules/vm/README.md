# ⛰️ Homelab Alpine Terraform - VM Module

Creates a Proxmox VM wired for Alpine cloud-init images.

## 🔍 Notable defaults

- `cpu.type = "host"` unlocks extra CPU features (change it if you rely on
  live migration).
- `disk.cache = "writethrough"`, `discard = "on"`, `ssd = true` keep virtual
  SSDs healthy out of the box.
- Memory defaults to 2 GB with ballooning disabled (`floating = 0`).

## 🚀 Example usage

```hcl
module "alpine_image" {
	source    = "./modules/image"
	node_name = "bm-01"
}

module "alpine_vm" {
	source = "./modules/vm"

	node_name = "bm-01"
	vm_id     = 300
	vm_name   = "alpine-01"

	image_file_id = module.alpine_image.file_id
	disk = {
		datastore_id = "local-lvm"
		size         = 32
	}

	dns = {
		domain  = "lab.example.com"
		servers = ["10.0.0.5"]
	}

	ipv4 = {
		address = "10.0.0.30/24"
		gateway = "10.0.0.1"
	}

	user_account = {
		username = "alpine"
		password = "alpine" # please, store in a secret manager
		keys     = ["ssh-ed25519 AAAA... user@example"]
	}
}
```
