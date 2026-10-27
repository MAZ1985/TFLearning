
resource "azapi_resource" "ssh_public_key" {
  count = var.vm_count_lnx
  type = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name = "pub-${var.linux_name}-${count.index + 1}"
  location = var.location
  parent_id = var.resource_group_name.id
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  count = var.vm_count_lnx
  type = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key[count.index].id
  action = "generateKeyPair"
  method = "POST"
}
