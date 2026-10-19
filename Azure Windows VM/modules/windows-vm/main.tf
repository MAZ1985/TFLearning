
resource "azurerm_network_interface" "nic" {
    name = "windows-nic"
  location = var.location
  resource_group_name = var.resource_group_name
#    location = azurerm_resource_group.rg.location
#    resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
#    subnet_id = azurerm_subnet.rg_az_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}