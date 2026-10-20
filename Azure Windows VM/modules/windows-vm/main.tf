
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

 # for_each = var.allowed_ports

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