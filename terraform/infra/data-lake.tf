resource "azurerm_data_lake_store" "events_lake_store" {
  name                = "${var.environment}events"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_data_lake_analytics_account" "events_lake_account" {
  name                = "${var.environment}eventsdl"
  resource_group_name = var.resource_group_name
  location            = var.location

  default_store_account_name = "${azurerm_data_lake_store.events_lake_store.name}"
}