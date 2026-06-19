resource "aws_lb_target_group" "app" {

  name = "app-target-group"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  target_type = "instance"

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 3

    unhealthy_threshold = 3
  }

  tags = {
    Name = "app-target-group"
  }
}
