
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

variable "allowed_ports" {
    type = list(number)
    default = [ 80, 3389 ]
}

variable "storage_name" {
    type = string
    default = "winstorage01"
}

variable "windows_name" {
    type = string
    default = "win"
}

variable "vm_count_win" {
  type = number
}