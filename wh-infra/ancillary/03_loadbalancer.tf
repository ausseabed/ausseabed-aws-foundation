resource "aws_eip" "geoserver_eip" {
  count = length(var.networking.web_tier_subnets)
  vpc   = true
}

resource "aws_lb" "geoserver_load_balancer" {
  name               = "ga-sb-${var.env}-geoserver-lb"
  internal           = false
  load_balancer_type = "network"
  dynamic "subnet_mapping" {
    for_each = [ for i in range(length(var.networking.web_tier_subnets)): {
      subnet_id = var.networking.web_tier_subnets[i]
      allocation_id = aws_eip.geoserver_eip[i].id
    }]
    content {
      subnet_id = subnet_mapping.value.subnet_id
      allocation_id = subnet_mapping.value.allocation_id
    }
  }

  tags = {
    Environment = "nonproduction"
  }
}

resource "aws_lb_target_group" "geoserver_outside" {
  name     = "ga-sb-${var.env}-geoserver-outside"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.networking.vpc_id
  target_type = "ip"
  stickiness {
    enabled = false
    type = "lb_cookie"
  }
  depends_on = [
    aws_lb.geoserver_load_balancer
  ]
}


resource "aws_lb_listener" "geoserver_load_balancer_listener" {
  load_balancer_arn = aws_lb.geoserver_load_balancer.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.geoserver_outside.arn
  }
}
