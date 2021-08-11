resource "aws_ecs_cluster" "cluster" {
  name               = local.ecs["cluster_name"]
  # capacity_providers = ["FARGATE"]
  # default_capacity_provider_strategy {
  #   capacity_provider = "FARGATE"
  #   weight            = "100"
  # }
}

resource "aws_ecs_task_definition" "task" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.fargate.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  container_definitions = jsonencode([
    {
      name      = local.container.name
      image     = "${local.container.image}:latest"
      essential = true
      portMappings = [{
        protocol      = "tcp"
        containerPort = 80
        hostPort      = 80
      }]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = local.ecs.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  force_new_deployment = true
  desired_count   = 2
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.subnet_public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.group.arn
    container_name   = local.container.name
    container_port   = 80
  }
  # deployment_controller {
  #   type = "ECS"
  # }
  # capacity_provider_strategy {
  #   base              = 0
  #   capacity_provider = "FARGATE"
  #   weight            = 100
  # }
  lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}