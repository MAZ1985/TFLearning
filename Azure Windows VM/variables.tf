
# Declare a variable for input.
variable "rg_name" {
  type = string
  default = "rg_az"
  description = "Resource Group Name."
}

variable "rg_loc" {
    type = string
    default = "Malaysia West"
    description = "Resource Group location."
}

variable "vm_count_win" {
  type = number
  default = 0
}

variable "vm_count_lnx" {
  type = number
  default = 1
}