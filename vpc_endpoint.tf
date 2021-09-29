## CloudWatch Logs用
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.vpc_main.id
  service_name      = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private-a.id, aws_subnet.private-c.id]
  security_group_ids = [
    module.vpc_endpoint.security_group_id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.project-name}-vpce-logs"
  }
}

# ECR
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.vpc_main.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private-a.id, aws_subnet.private-c.id]
  security_group_ids = [
    module.vpc_endpoint.security_group_id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.project-name}-ecr-api"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.vpc_main.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private-a.id, aws_subnet.private-c.id]
  security_group_ids = [
    module.vpc_endpoint.security_group_id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.project-name}-ecr-dkr"
  }
}
