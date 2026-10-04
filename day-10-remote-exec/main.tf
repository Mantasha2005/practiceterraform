provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sql_runner" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  key_name                    = "terraform-remote-exec"
  associate_public_ip_address = true

  tags = {
    Name = "SQL Runner"
  }
}

resource "aws_db_instance" "mysql_rds" {
  identifier          = "my-mysql-db-remote"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = var.db_password
  db_name             = "dev"
  allocated_storage   = 20
  skip_final_snapshot = true
  publicly_accessible = true
}

resource "null_resource" "remote_sql_exec" {
  depends_on = [
    aws_db_instance.mysql_rds,
    aws_instance.sql_runner
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/asus/Downloads/terraform-remote-exec.pem")
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install mariadb105-server -y",
      "mysql --version",
      "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -p'${var.db_password}' dev < /tmp/init.sql"
    ]
  }

  triggers = {
    sql_file = filemd5("init.sql")
  }
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}



