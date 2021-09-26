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
