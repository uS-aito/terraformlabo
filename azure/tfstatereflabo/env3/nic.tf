data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name = "tfstatestorageaccountrg"
    storage_account_name = "tfstatestorage0627"
    container_name = "tfstate"
    key = "tfstatereflabo01.tfstate"
  }
}

resource "azurerm_network_interface" "samplenic" {
    name = "samplenic"
    location = "japaneast"
    resource_group_name = data.terraform_remote_state.vnet.outputs.vnet_rg

    ip_configuration {
      name = "ipconfig"
      subnet_id = data.terraform_remote_state.vnet.outputs.subnet_id
      private_ip_address_allocation = "Dynamic"
    }
}