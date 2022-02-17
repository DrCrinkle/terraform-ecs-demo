provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket         = "taylora-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-taylor"
  }
}
