resource "azurerm_container_group" "events" {
  name                = "${var.environment}-events"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "${var.environment}-events"
    image  = "stanpogrebnyak/lobster:latest"
    cpu    = "0.5"
    memory = "1.5"

    environment_variables = {
        "EventHubConnectionString" : "${azurerm_eventhub_namespace.events_hub_namespace.default_primary_connection_string}",
        "EventHubName" : "${azurerm_eventhub.events_hub.name}"
    }

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = var.environment
  }
}