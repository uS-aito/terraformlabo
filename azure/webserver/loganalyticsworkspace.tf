resource "azurerm_log_analytics_workspace" "webserverlogana" {
    name = "webserverlogana"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "PerGB2018"
    retention_in_days = 30
}

resource "azurerm_log_analytics_solution" "example" {
  solution_name         = "VMInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.webserverlogana.id
  workspace_name        = azurerm_log_analytics_workspace.webserverlogana.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}