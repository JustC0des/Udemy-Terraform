# Define AWS Provider
provider "aws" {
  region = "eu-central-1"
}

provider "azurerm" {
  features {}
}

# AWS Resourcen

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1b"
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "multi-cloud-db-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  description = "Subnet group for RDS instance"
}

resource "aws_db_instance" "postgres" {
  identifier            = "multi-cloud-db"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username            = "PostgresAdmin"
  password            = "SuperSecurePass123!"
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}





# Azure Resourcen

resource "azurerm_resource_group" "rg" {
  name     = "multi-cloud-rg"
  location = "Germany West Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "multi-cloud-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "multi-cloud-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                    = "multi-cloud-nic"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet.id
    public_ip_address_id         = azurerm_public_ip.vm_public_ip.id 
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "multi-cloud-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1ms"
  admin_username        = "azureuser"
  admin_password        = "AzureSecurePass123!"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic.id] 

  os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    disk_size_gb      = 30
    storage_account_type = "Standard_LRS" 
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "multi-cloud"
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "multi-cloud-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}