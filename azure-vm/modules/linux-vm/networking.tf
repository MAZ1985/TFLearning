
# Create public IP's.
resource "azurerm_public_ip" "pub_ip_lnx" {
    count = var.vm_count_lnx
    name = "${var.linux_name}-pubip-${count.index + 1}"
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_network_interface" "nic" {
  count = var.vm_count_lnx
  name = "linux-nic-${count.index + 1}"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "internal_linux"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pub_ip_lnx[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "interface_sec_group" {
  count = var.vm_count_lnx
  network_interface_id = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.lnx_sec_group.id
}