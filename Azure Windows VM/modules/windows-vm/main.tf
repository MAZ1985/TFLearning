
resource "azurerm_network_interface" "nic" {
    name = "windows-nic"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "win_sec_group" {
  name = var.sec_group
  location = var.location
  resource_group_name = var.resource_group_name

#  for_each = {
#    for idx, port in var.allowed_ports :
#    port => {
#      priority = 100 + idx
#      port = port
#    }
#  }

  for_each = var.allowed_ports

  security_rule = {
    name = each.key
    priority = 100 + index(keys(var.allowed_ports), each.key)
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = each.value
    source_address_prefix = "*"
    destination_address_prefix ="*"
  }

  
}