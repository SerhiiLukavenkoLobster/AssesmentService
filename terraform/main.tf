resource "azurerm_resource_group" "test" {
  name     = "SPA-functions"
  location = "West Europe"

  tags = {
    Environment = "Test"
  }
}

variable "azure_subscription_id" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}

module "infra" {
  source                    = "./infra"
  resource_group_name       = azurerm_resource_group.test.name
  environment               = "test"
}
