
resource "azurerm_network_interface" "nic" {
    name = "windows-nic"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.pub_ip
  }
}

resource "azurerm_network_security_group" "win_sec_group" {
  name = var.sec_group
  location = var.location
  resource_group_name = var.resource_group_name


  dynamic "security_rule" {

    for_each = var.allowed_ports

    content {
    name = "Allow-${security_rule.value}"
    priority = 100 + index(var.allowed_ports, security_rule.value)
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = security_rule.value
    source_address_prefix = "*"
    destination_address_prefix ="*"
  }
  }
  
}

resource "azurerm_network_interface_security_group_association" "interface_sec_group" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.win_sec_group.id
}

# Storage account for boot diagnostic.
resource "azurerm_storage_account" "storage_account" {
  name = var.storage_name
  location = var.location
  resource_group_name = var.resource_group_name
  
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "random_password" "windows_password" {
  length = 15
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
  special = true
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name = var.windows_name
  admin_username = "azureuser"
  admin_password = random_password.windows_password.result
  location = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size = "Standard_DS1_v2"

  os_disk {
    name = "winosdisk"
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