module "gitsource" {
  source = "https://github.com/CloudTechDevOps/Terraform0730/archive/refs/heads/main.zip//Terraform0730-main/Day-6-modules"
  ami = "ami-0e34b50e714a297f1"
  instance_type = "t2.micro"
}