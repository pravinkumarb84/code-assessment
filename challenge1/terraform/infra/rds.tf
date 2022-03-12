resource "aws_db_instance" "assessment_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.27"
  instance_class         = "db.t3.micro"
  db_name                = "assessmentdb"
  username               = "test"
  password               = "password12"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  db_subnet_group_name   = "rds_sub"
  depends_on = [
    aws_security_group.rds_sg, aws_db_subnet_group.rds_sub
  ]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "rds security group"
  vpc_id      = aws_vpc.vpc_assessment.id

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}

resource "aws_db_subnet_group" "rds_sub" {
  name       = "rds_sub"
  count      = "1"
  subnet_ids = [aws_subnet.private[0].id,aws_subnet.private[1].id]

}