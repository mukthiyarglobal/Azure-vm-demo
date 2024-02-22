# Create a resource group
resource "azurerm_resource_group" "demo-RG" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo-RG.location
  resource_group_name = azurerm_resource_group.demo-RG.name
}

# Create a subnet
resource "azurerm_subnet" "demo-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.demo-RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP
resource "azurerm_public_ip" "example" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.demo-RG.location
  resource_group_name = azurerm_resource_group.demo-RG.name
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "example" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.demo-RG.location
  resource_group_name = azurerm_resource_group.demo-RG.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# # Create a network security group
resource "azurerm_network_security_group" "example" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.demo-RG.location
  resource_group_name = azurerm_resource_group.demo-RG.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = var.nsg_rule_name
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = var.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demo-RG.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http"
  resource_group_name         = azurerm_resource_group.demo-RG.name
  network_security_group_name = azurerm_network_security_group.example.name
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create a virtual machine
resource "azurerm_virtual_machine" "example" {
  name                  = var.vm_name
  location              = azurerm_resource_group.demo-RG.location
  resource_group_name   = azurerm_resource_group.demo-RG.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = var.vm_size # Change this to your desired VM size

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = var.os_disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_type
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password # Change this to your desired password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  #  provisioner "file" {
  #    source      = "/var/lib/jenkins/workspace/terrademo/build"
  #    destination = "/var/build"


  provisioner "remote-exec" {
    inline = [
      #        "chmod -R +x /tmp/build",
      #        "/var/build args",
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo apt-get install -y nodejs",
      "sudo apt-get install -y npm",
      " cd /var/www/html",
      "sudo git clone -b master https://github.com/mukthiyarglobal/demo-terra11.git ",
      "cd demo-terrall",
      "npm run install",
      "npm run build",
      #     # "sudo systemctl status apache2",
      #     # "sudo systemctl restart apache2",
    ]
  }
  connection {
    # type        = "ssh"
    host     = azurerm_public_ip.example.ip_address
    user     = var.admin_username
    password = var.admin_password
    #   # private_key = file("/root/.ssh/id_rsa.pub")
    #   # timeout     = "4m"
  }
  # provisioner "file" {
  #   source      = "/var/lib/jenkins/workspace/terrademo"
  #   destination = "/tmp"

  #   connection {
  # type        = "ssh"
  #     host     = azurerm_public_ip.example.ip_address
  #     user     = var.admin_username
  #     password = var.admin_password
  # private_key = file("/root/.ssh/id_rsa.pub")
  # timeout     = "4m"
  #   }

  # admin_ssh_key {
  #     username   = var.admin_username
  #     public_key = file("~/.ssh/id_rsa.pub")
  # }
  #  }
}



