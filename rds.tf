resource "aws_db_subnet_group" "main" {

  name = "main-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]

  tags = {
    Name = "DB Subnet Group"
  }
}
resource "aws_db_instance" "mysql" {

  identifier = "multi-tier-db"

  allocated_storage = 20

  storage_type = "gp3"

  engine = "mysql"

  engine_version = "8.0"

  instance_class = "db.t3.micro"

  db_name = "appdb"

  username = "admin"

  password = "Pass12345"

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "mysql-rds"
  }
}
