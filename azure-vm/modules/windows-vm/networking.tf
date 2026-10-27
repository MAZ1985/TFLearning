# Standard sku is "Standard" if not define under resource, however it seem the error stated that we use "Basic"
# instead of "Standard" hence i define under this resource and need to put IP as static as "Standard" sku can't
# be implement using "Dynamic". However, maybe its declare as "Standard" but the allocation_method last time i set
# to "Dynamic" where i only change it to "Static" at the same time when i define the sku to "Standard". Need to test.
resource "azurerm_public_ip" "pub_ip" {
  count = var.vm_count_win
  name = "${var.windows_name}-pubip-${count.index + 1}"
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

resource "azurerm_network_interface_security_group_association" "interface_sec_group" {
  count = var.vm_count_win
  network_interface_id = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.win_sec_group.id
}