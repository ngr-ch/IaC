variable "resource_group_location" {
  default     = "East Us"
  description = "Location of the cosmo DB"
}

variable "resource_group_name" {
  default     = "RG_Nagaraju"
  description = "resource group name"
}

variable "failover_location" {
  default = "Central Us"
}
variable "cosmos_db_account_name" {
  default     = "ng-db-acc"
  description = "Cosmo DB Account name"
}
variable "prefix" {
  default     = "prod"
  description = "Environment name"
}

variable "cosmos_db_name" {
  default     = "ngr-db"
  description = "DataBase name"
}

/* variable "cosmos_db_containers_name" {
  type        = list(string)
  default     = ["Appearance", "Article", "AssignedProductDevelopment"]
  description = "Containers List names"
} */

variable "cosmos_db_containers_name" {
  type = map(string)
  default = {
    Appearance = 300
    Article    = 400
    Colour     = 500
  }
}
