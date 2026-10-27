
variable "resource_group_name" {
  type = string
}

variable "resource_group_id" {
    type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "linux_name" {
    type = string
    default = "lnx"
}

variable "vm_count_lnx" {
  type = number
}

variable "lnx_sec_group" {
    type = string
    default = "lnx_sec_group"
    description = "Linux Security Group"
}

variable "security_rules" {
    type = list(object({
      name = string
      priority = number
      direction = string
      protocol = string
      port = number 
    }))
    
    default = [
    {
        name = "AllowInbound-RDP"
        priority = 101
        direction = "Inbound"
        protocol = "Tcp"
        port = 3389
    },
    {
        name = "AllowInbound-HTTP"
        priority = 102
        direction = "Inbound"
        protocol = "Tcp"
        port = 80
    },
    {
        name = "AllowInbound-HTTPS"
        priority = 103
        direction = "Inbound"
        protocol = "Tcp"
        port = 443
    },
    {
        name = "AllowOutbound-HTTP"
        priority = 200
        direction = "Outbound"
        protocol = "Tcp"
        port = 80
    },
    {
        name = "AllowOutbound-HTTPS"
        priority = 201
        direction = "Outbound"
        protocol = "Tcp"
        port = 443
    }  
    ]
}

variable "storage_name" {
    type = string
    default = "lnxstorage01"
}

variable "user_name" {
    type = string
    default = "azuser"
}