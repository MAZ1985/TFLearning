
terraform {
  cloud {
    organization = "azizul"
    hostname = "app.terraform.io"

  workspaces {
    project = "TFLearning"
  }
  }
}