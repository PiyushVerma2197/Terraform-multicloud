# AWS LoadBalancer
resource "aws_lb" "app" {

  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets                    = aws_subnet.public[*].id
  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}

# Target Group 
resource "aws_lb_target_group" "app" {

  name     = "${var.environment}-app-tg"
  port     = 32652
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    enabled             = true
    path                = "/healthz"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name        = "${var.environment}-app-tg"
    Environment = var.environment
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Attach EKS node group's ASG to the ALB target group
resource "aws_autoscaling_attachment" "eks_nodes" {
  autoscaling_group_name = aws_eks_node_group.this.resources[0].autoscaling_groups[0].name
  lb_target_group_arn    = aws_lb_target_group.app.arn
}

# # Find EC2 instances belonging to the EKS node group
# data "aws_instances" "eks_nodes" {

#     depends_on = [
#     aws_eks_node_group.this
#   ]
#   filter {
#     name   = "tag:eks:nodegroup-name"
#     values = ["${var.environment}-eks-node-group"]
#   }

#   filter {
#     name   = "instance-state-name"
#     values = ["running"]
#   }
# }

# # Register EKS worker nodes in the existing ALB target group
# resource "aws_lb_target_group_attachment" "eks_nodes" {
#   for_each = toset(data.aws_instances.eks_nodes.ids)

#   target_group_arn = aws_lb_target_group.app.arn
#   target_id        = each.value
#   port             = 32652
# }