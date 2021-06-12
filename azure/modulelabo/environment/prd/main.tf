resource "azurerm_resource_group" "rg" {
    name = "modulelaborg"
    location = "japaneast"
}

module "vnet" {
    source = "../../module/vnet"
    vnet_name = "vnet"
    rg = azurerm_resource_group.rg.name
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg.location
    subnet_name = "subnet"
    subnet_address_prefix = [["10.0.1.0/24"],["10.0.2.0/24"]]
}