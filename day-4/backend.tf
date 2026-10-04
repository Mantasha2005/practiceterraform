terraform {
  backend "s3" {
    bucket = "statefile-store-nit"
    key    = "terraform-statefile/terraform.tfstate"
    region = "us-east-1"
  }
}