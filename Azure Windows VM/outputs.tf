
# Declare outputs to be able to view after terraform create.

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
    value = azurerm_resource_group.rg.location
}

output "rg_vnetwork_subnet" {
    value = azurerm_virtual_network.rg_az_vnetwork.subnet
}
 
output "rg_az_subnet" {
    value = azurerm_subnet.rg_az_subnet.id
}

output "windows_admin_password" {
    value = module.windows-vm.windows_admin_password
    sensitive = true
}