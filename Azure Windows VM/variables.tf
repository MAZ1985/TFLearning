
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