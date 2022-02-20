# Let's try to create MySQL server:
resource "azurerm_mysql_server" "terraform_course_mysql" {
  name = "${var.project_name}-mysql"
  location = var.resource_location
  resource_group_name = azurerm_resource_group.terraform_course.name

  sku_name = "GP_Gen5_2"

  storage_mb = 5120
  backup_retention_days = 7
  geo_redundant_backup_enabled = "false"
  auto_grow_enabled = "false"

  administrator_login = var.srv_admin_username
  administrator_login_password = var.srv_admin_password
# I will use the same login and pass, because I'm too lazy to create a separate account =)
  version = "5.7"
  ssl_enforcement_enabled = "true"
}

# And the database:
resource "azurerm_mysql_database" "database" {
  name                = "${var.project_name}db"
  resource_group_name = azurerm_resource_group.terraform_course.name
  server_name         = azurerm_mysql_server.terraform_course_mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
