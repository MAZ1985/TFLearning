
output "windows_admin_password" {

    value = azurerm_windows_virtual_machine.windows_vm[*].admin_password
}