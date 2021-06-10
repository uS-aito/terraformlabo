# resource "azurerm_public_ip" "agwpip" {
#   name = "agwpip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location = azurerm_resource_group.rg.location
#   allocation_method = "Dynamic"
# }

# locals {
#   backend_address_pool_name = "${azurerm_virtual_network.webvirtualnetwork.name}-beap"
#   frontend_port_name             = "${azurerm_virtual_network.webvirtualnetwork.name}-feport"
#   frontend_ip_configuration_name = "${azurerm_virtual_network.webvirtualnetwork.name}-feip"
#   http_setting_name              = "${azurerm_virtual_network.webvirtualnetwork.name}-be-htst"
#   listener_name                  = "${azurerm_virtual_network.webvirtualnetwork.name}-httplstn"
#   request_routing_rule_name      = "${azurerm_virtual_network.webvirtualnetwork.name}-rqrt"
#   redirect_configuration_name    = "${azurerm_virtual_network.webvirtualnetwork.name}-rdrcfg"
# }

# resource "azurerm_application_gateway" "webserverag" {
#   name = "webserverag"
#   resource_group_name = azurerm_resource_group.rg.name
#   location = azurerm_resource_group.rg.location

#   sku {
#       name = "Standard_Small"
#       tier = "Standard"
#       capacity = 2
#   }

#   gateway_ip_configuration {
#     name = "gateway_ip_configuration"
#     subnet_id = azurerm_subnet.frontendsubnet.id
#   }

#   frontend_port {
#     name = local.frontend_port_name
#     port = 80
#   }

#   frontend_ip_configuration {
#     name = local.frontend_ip_configuration_name
#     public_ip_address_id = azurerm_public_ip.agwpip.id
#   }

#   backend_address_pool {
#     name = local.backend_address_pool_name
#   }

#   backend_http_settings {
#     name = local.http_setting_name
#     cookie_based_affinity = "Disabled"
#     path = "/"
#     port = 80
#     protocol = "Http"
#     request_timeout = 60
#   }

#   http_listener {
#     name = local.listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name = local.frontend_port_name
#     protocol = "Http"
#   }

#   request_routing_rule {
#     name = local.request_routing_rule_name
#     rule_type = "Basic"
#     http_listener_name = local.listener_name
#     backend_address_pool_name = local.backend_address_pool_name
#     backend_http_settings_name = local.http_setting_name
#   }
# }