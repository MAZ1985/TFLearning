# Create storage account.
resource "azurerm_storage_account" "lnx_storage_account" {
  name = var.storage_name
  location = var.location
  resource_group_name = var.resource_group_name
  account_tier = "Standard"
  account_replication_type = "LRS"
}

# Create Linux Virtual Machine.
resource "azurerm_linux_virtual_machine" "linux_vm" {
  count = var.vm_count_lnx
  
  name = "${var.linux_name}0${count.index + 1}"
  location = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size = "Standard_DS1_v2"

  os_disk {
    name = "lnxosdisk0${count.index + 1}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts-gen2"
    version = "latest"
  }

  computer_name = "hostname"
  admin_username = var.user_name

  admin_ssh_key {
    username = var.user_name
    public_key = azapi_resource_action.ssh_public_key_gen[count.index].output.publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.lnx_storage_account.primary_blob_endpoint
  }
}