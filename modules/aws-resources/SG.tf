resource "aws_security_group" "alb" {

  name        = "${var.environment}-alb-sg"
  description = "Security group for application load balancer"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "app" {

  name        = "${var.environment}-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Application traffic from ALB"
    from_port       = 32652
    to_port         = 32652
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "database" {

  name        = "${var.environment}-database-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Database traffic from application"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # security_groups = [aws_security_group.app.id]

    security_groups = [
      aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-database-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "alb_to_eks_nodeport" {
  description              = "Allow ALB to reach NGINX NodePort"
  type                     = "ingress"
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  from_port                = 32652
  to_port                  = 32652
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}