
resource "azurerm_network_security_group" "win_sec_group" {
  name = var.sec_group
  location = var.location
  resource_group_name = var.resource_group_name


  dynamic "security_rule" {

    for_each = var.security_rules

    content {
    name = security_rule.value.name
    priority = security_rule.value.protocol
    direction = security_rule.value.direction
    access = "Allow"
    protocol = security_rule.value.protocol
    source_port_range = "*"
    destination_port_range = security_rule.value.port
    source_address_prefix = "*"
    destination_address_prefix ="*"
    }
  }
}