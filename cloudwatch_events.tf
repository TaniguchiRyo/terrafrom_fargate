resource "aws_cloudwatch_event_rule" "batch" {
  name                = "${var.project-name}-batch"
  description         = "use batch"
  schedule_expression = "cron(*/2 * * * ? *)"

  # schedule stop
  is_enabled = false
}

resource "aws_cloudwatch_event_target" "batch" {
  target_id = "${var.project-name}-batch"
  rule      = aws_cloudwatch_event_rule.batch.name
  role_arn  = module.ecs_events_role.iam_role_arn
  arn       = aws_ecs_cluster.cluster.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    platform_version    = "1.3.0"
    task_definition_arn = aws_ecs_task_definition.batch_task_definition.arn

    network_configuration {
      assign_public_ip = "false"
      subnets          = [aws_subnet.private-a.id]
    }
  }
}
