# Create a virtual network
resource "azurerm_virtual_network" "lab_vnet" {
  name                = "lab-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "labs"
  }
}

# Create subnets
resource "azurerm_subnet" "lab_public_subnet" {
  name                 = "lab-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.0.0.0/23"]
}

resource "azurerm_subnet" "lab_private_subnet" {
  name                 = "lab-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

# Create network security groups
resource "azurerm_network_security_group" "lab_public_nsg" {
  name                = "lab-public-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.lab_public_nsg.name
}


resource "azurerm_network_security_rule" "http" {
  name                        = "HTTP"
  priority                    = 410
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.lab_public_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "lab_public_nsg_association" {
  subnet_id                 = azurerm_subnet.lab_public_subnet.id
  network_security_group_id = azurerm_network_security_group.lab_public_nsg.id
}


resource "azurerm_network_security_group" "lab_private_nsg" {
  name                = "lab-private-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "lab_private_nsg_association" {
  subnet_id                 = azurerm_subnet.lab_private_subnet.id
  network_security_group_id = azurerm_network_security_group.lab_private_nsg.id
}