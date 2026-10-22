# Storage account for boot diagnostic.
resource "azurerm_storage_account" "storage_account" {
  name = var.storage_name
  location = var.location
  resource_group_name = var.resource_group_name
  public_network_access_enabled = false
  
  account_tier = "Standard"
  account_replication_type = "LRS"
  
}

resource "random_password" "windows_password" {
  count = var.vm_count_win
  length = 15
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
  special = true
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  count = var.vm_count_win
  name = "${var.windows_name}0${count.index + 1}"
  admin_username = "azureuser"
  admin_password = random_password.windows_password[count.index].result
  location = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size = "Standard_DS1_v2"

  os_disk {
    name = "winosdisk0${count.index}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-datacenter-azure-edition"
    version = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }
}