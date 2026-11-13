data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "wp_sg" {
  name        = "legacy-wp-dev-sg"
  description = "Allow inbound SSH and HTTP traffic"

  ingress {
    description = "SSH from Admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "HTTP from CloudFront to WordPress container"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "legacy-wp-dev-sg"
    Project     = "legacy-wp"
    Environment = "dev"
    ManagedBy   = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}