# --- loadbalancing/main.tf ---

resource "aws_lb" "rdb_lb" {
  name            = "rdb-lb"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400

}

resource "aws_lb_target_group" "rdb_tg" {
  name     = "rdb-lb-tg-${substr(uuid(), 0, 4)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}

resource "aws_lb_listener" "rdb_lb_listener" {
  load_balancer_arn = aws_lb.rdb_lb.arn
  port              = var.listerner_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rdb_tg.arn
  }
}