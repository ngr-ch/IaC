data "azurerm_resource_group" "rg" {
  name = var.resource_group_name

}
resource "azurerm_cosmosdb_account" "acc" {
  name                      = "${var.cosmos_db_account_name}-${var.prefix}"
  location                  = data.azurerm_resource_group.rg.location
  resource_group_name       = data.azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = true

  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }
  geo_location {
    location          = var.resource_group_location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "accdb" {
  name                = var.cosmos_db_name
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.acc.name
}

resource "azurerm_cosmosdb_sql_container" "dbcon" {
  #count                = length(var.cosmos_db_containers_name)
  #name                 = var.cosmos_db_containers_name[count.index]
  #for_each             = toset(var.cosmos_db_containers_name)
  for_each              = var.cosmos_db_containers_name
  name                  = each.key
  resource_group_name   = data.azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.acc.name
  database_name         = azurerm_cosmosdb_sql_database.accdb.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1
  throughput            = 400
  default_ttl           = each.value

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}