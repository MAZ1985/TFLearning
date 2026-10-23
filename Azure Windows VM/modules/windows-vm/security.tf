
resource "azurerm_network_security_group" "win_sec_group" {
  name = var.sec_group
  location = var.location
  resource_group_name = var.resource_group_name


  dynamic "security_rule" {

    for_each = var.security_rules

    content {
    name = security_rules.value.name
    priority = security_rules.value.protocol
    direction = security_rules.value.direction
    access = "Allow"
    protocol = security_rules.value.protocol
    source_port_range = "*"
    destination_port_range = security_rules.value.port
    source_address_prefix = "*"
    destination_address_prefix ="*"
    }
  }
}