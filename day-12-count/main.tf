variable "environment" {
  type    = string
  default = "prod"
}

resource "aws_instance" "example" {
  count         = var.environment == "prod" ? 3 : 1
  ami           = "ami-0f8848d57eb4fe2d2"
  instance_type = "t2.micro"

  tags = {
    Name = "example-${count.index}"
  }
}