data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name = "tfstatestorageaccountrg"
    storage_account_name = "tfstatestorage0627"
    container_name = "tfstate"
    key = "tfstatereflabo01.tfstate"
  }
}

resource "azurerm_subnet" "subnet" {
  name = "subnet"
  resource_group_name = data.terraform_remote_state.vnet.outputs.vnet_rg
  virtual_network_name = data.terraform_remote_state.vnet.outputs.vnet_name
  address_prefixes = ["10.0.0.0/24"]
}