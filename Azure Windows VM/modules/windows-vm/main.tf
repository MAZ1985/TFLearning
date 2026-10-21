
# Standard sku is "Standard" if not define under resource, however it seem the error stated that we use "Basic"
# instead of "Standard" hence i define under this resource and need to put IP as static as "Standard" sku can't
# be implement using "Dynamic". However, maybe its declare as "Standard" but the allocation_method last time i set
# to "Dynamic" where i only change it to "Static" at the same time when i define the sku to "Standard". Need to test.
resource "azurerm_public_ip" "pub_ip" {
  count = var.vm_count_win
  name = "{$var.windows_name}-pubip-{$count.index + 1}"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "nic" {
  count = var.vm_count_win
  name = "windows-nic-${count.index + 1}"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pub_ip[count.index].id
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
  count = var.vm_count_win
  network_interface_id = azurerm_network_interface.nic[count.index].id
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
  count = var.vm_count_win
  name = "{$var.windows_name}-{$count.index + 1}"
  admin_username = "azureuser"
  admin_password = random_password.windows_password.result
  location = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
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