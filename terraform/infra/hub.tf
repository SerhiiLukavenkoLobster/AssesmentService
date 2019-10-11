resource "azurerm_eventhub_namespace" "events_hub_namespace" {
  name                = "${var.environment}hubnamespace2019"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  kafka_enabled       = false

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub" "events_hub" {
  name                = "${var.environment}Hub"
  namespace_name      = azurerm_eventhub_namespace.events_hub_namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1

  capture_description {
      enabled = true
      encoding = "Avro"
      interval_in_seconds = 60
      skip_empty_archives = true
      destination {
          name = "EventHubArchive.AzureBlockBlob"
          archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
          blob_container_name = azurerm_storage_container.hub_events_store.name
          storage_account_id = azurerm_storage_account.hub_events_store_account.id
      }
  }
}

resource "azurerm_storage_account" "hub_events_store_account" {
  name                     = "${var.environment}hubstoreaccount"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "hub_events_store" {
  name                  = "${var.environment}hubeventsstore"
  storage_account_name  = azurerm_storage_account.hub_events_store_account.name
  container_access_type = "private"
}