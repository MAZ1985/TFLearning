
# Create a resource group.
resource "azurerm_resource_group" "rg" {
    name = var.rg_name
    location = var.rg_loc

    timeouts {
        create = "10m"
        delete = "15m"
    }
}

resource "azurerm_virtual_network" "rg_az_vnetwork" {
    name = "${var.rg_name}-network"
    location = var.rg_loc
    resource_group_name = var.rg_name
    address_space = ["10.0.0.0/16"]

    depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_subnet" "rg_az_subnet" {
  name = "${var.rg_name}-subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.rg_az_vnetwork.name
  address_prefixes = ["10.0.1.0/24"]
}

module "windows-vm" {

    count = var.vm_count_win > 0 ? 1 : 0
    source = "./modules/windows-vm"

    resource_group_name = var.rg_name
    location = var.rg_loc
    subnet_id = azurerm_subnet.rg_az_subnet.id
    vm_count_win = var.vm_count_win

    depends_on = [ azurerm_virtual_network.rg_az_vnetwork ]

}

module "linux-vm" {

    count = var.vm_count_lnx > 0 ? 1 : 0
    source = "./modules/linux-vm"

    resource_group_name = var.rg_name
    location = var.rg_loc
    subnet_id = azurerm_subnet.rg_az_subnet.id
    vm_count_lnx = var.vm_count_lnx
    resource_group_id = azurerm_resource_group.rg.id

    depends_on = [ azurerm_virtual_network.rg_az_vnetwork ]
}