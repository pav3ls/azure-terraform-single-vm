#Add ssh key
resource "azurerm_ssh_public_key" "lab" {
  name                = "lab-ssh-key"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = var.ssh_public_key
}

# Creating cloud-init
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = file("web.conf")
  }
}

#Create Public IP
resource "azurerm_public_ip" "vm_public_web_pip" {
  name                = "lab-vm-public-web-01-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

#Create NIC
resource "azurerm_network_interface" "vm_public_web_nic" {
  name                = "lab-vm-public-web-01-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.lab_public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_web_pip.id
  }
}

#Create Virtual Machine
resource "azurerm_linux_virtual_machine" "vm_public_web" {
  name                  = "lab-vm-public-web-01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_public_web_nic.id]
  size                  = "Standard_B1s"
  custom_data           = data.template_cloudinit_config.config.rendered

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts"
    version   = "latest"
  }

  os_disk {
    name         = "lab-vm-public-web-01-osdisk1"
    disk_size_gb = "30"
    caching      = "ReadWrite"

    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "lab-vm-public-web-01"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = azurerm_ssh_public_key.lab.public_key
  }


}