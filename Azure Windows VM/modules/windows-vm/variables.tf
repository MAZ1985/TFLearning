
variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "sec_group" {
    type = string
    default = "win-sec-group"
    description = "Windows Security Group"
}

#variable "allowed_ports" {
#    type = list(number)
#    default = [ 80, 3389 ]
#}

variable "allowed_ports" {
    type = map(number)

    default = {
      RDP = 3389
      HTTP = 80
    }
}