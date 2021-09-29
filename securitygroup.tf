# ALB
module "http_sg" {
  source      = "./security_group"
  name        = "${var.project-name}-http-sg"
  vpc_id      = aws_vpc.vpc_main.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "./security_group"
  name        = "${var.project-name}-https-sg"
  vpc_id      = aws_vpc.vpc_main.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "./security_group"
  name        = "${var.project-name}-http-redirect-sg"
  vpc_id      = aws_vpc.vpc_main.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

# nginx
module "nginx_sg" {
  source      = "./security_group"
  name        = "${var.project-name}-nginx-sg"
  vpc_id      = aws_vpc.vpc_main.id
  port        = 80
  cidr_blocks = [aws_vpc.vpc_main.cidr_block]
}

# VPC endpoint
module "vpc_endpoint" {
  source = "./security_group"
  name   = "${var.project-name}-vpc-endpoint"
  vpc_id = aws_vpc.vpc_main.id
  port   = 443
  cidr_blocks = [
    aws_subnet.private-a.cidr_block,
    aws_subnet.private-c.cidr_block
  ]
}

# RDS
module "rds_sg" {
  source      = "./security_group"
  name        = "${var.project-name}-rds-sg"
  vpc_id      = aws_vpc.vpc_main.id
  port        = 3306
  cidr_blocks = [aws_vpc.vpc_main.cidr_block]
}
