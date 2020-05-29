resource "aws_eip" "geoserver_eip" {
  count = length(var.networking.web_tier_subnets)
  vpc   = true
}

resource "aws_lb" "geoserver_load_balancer" {
  name               = "ga-sb-${var.env}-geoserver-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.warehouse_lb_sb.id
  ]

  dynamic "subnet_mapping" {
    for_each = [for i in range(length(var.networking.web_tier_subnets)): {
      subnet_id = var.networking.web_tier_subnets[i]
      //      allocation_id = aws_eip.geoserver_eip[i].id
    }]
    content {
      subnet_id = subnet_mapping.value.subnet_id
      //      allocation_id = subnet_mapping.value.allocation_id
    }
  }

  tags = {
    Environment = "nonproduction"
  }
}

resource "aws_lb_target_group" "geoserver_outside" {
  name        = "ga-sb-${var.env}-geoserver-outside"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.networking.vpc_id
  target_type = "ip"

  health_check {
    enabled  = true
    interval = 300
    timeout  = 120
  }
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  depends_on = [
    aws_lb.geoserver_load_balancer
  ]
}


resource "aws_lb_listener" "geoserver_load_balancer_listener" {
  load_balancer_arn = aws_lb.geoserver_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.geoserver_outside.arn
  }
}


resource "aws_lb_listener" "geoserver_load_balancer_listener_https" {
  certificate_arn   = aws_acm_certificate.warehouse_cert.arn
  load_balancer_arn = aws_lb.geoserver_load_balancer.arn

  port     = "443"
  protocol = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.geoserver_outside.arn
  }
  depends_on = [
    aws_acm_certificate.warehouse_cert]
}
