
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

# Standard sku is "Standard" if not define under resource, however it seem the error stated that we use "Basic"
# instead of "Standard" hence i define under this resource and need to put IP as static as "Standard" sku can't
# be implement using "Dynamic". However, maybe its declare as "Standard" but the allocation_method last time i set
# to "Dynamic" where i only change it to "Static" at the same time when i define the sku to "Standard". Need to test.
resource "azurerm_public_ip" "pub_ip" {
  name = var.public_ip
  location = var.rg_loc
  resource_group_name = var.rg_name
  allocation_method = "Static"
  sku = "Standard"
}

module "windows-vm" {
    source = "./modules/windows-vm"

    resource_group_name = var.rg_name
    location = var.rg_loc
    subnet_id = azurerm_subnet.rg_az_subnet.id
    win_pub_ip = azurerm_public_ip.pub_ip.id

}