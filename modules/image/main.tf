locals {
  image_version            = trim(var.image.version, "v")
  image_version_components = compact(split(".", local.image_version))
  image_version_major      = local.image_version_components[0]
  image_version_minor      = local.image_version_components[1]
  derived_branch_name      = length(local.image_version_components) >= 2 ? format("v%s.%s", local.image_version_major, local.image_version_minor) : format("v%s", local.image_version_major)
  release_branch           = coalesce(var.image.release_branch, local.derived_branch_name)

  download_file_name = coalesce(
    var.download.file_name,
    format(
      "%s-%s-%s.%s",
      var.image.file_name_prefix,
      local.image_version,
      var.image.platform,
      var.image.artifact_extension,
    ),
  )

  download_url = coalesce(
    var.download.url,
    format(
      "%s/%s/releases/%s/%s",
      trim(var.image.base_url, "/"),
      local.release_branch,
      var.image.channel,
      local.download_file_name,
    ),
  )
}

resource "proxmox_virtual_environment_download_file" "this" {
  node_name    = var.node_name
  datastore_id = var.download.datastore_id
  content_type = var.download.content_type
  url          = local.download_url
  file_name    = local.download_file_name
}
