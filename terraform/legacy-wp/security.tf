# Security Group for Legacy WordPress EC2 Instance
resource "aws_security_group" "wp_sg" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Allow inbound SSH and HTTP traffic"

  # Inbound SSH restricted to administrative IP
  ingress {
    description = "SSH from Admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Can be restricted to your specific public IP /32 for maximum security
  }

  # Inbound HTTP for web traffic
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP for WordPress Docker container on port 8000
  ingress {
    description = "HTTP on port 8000 for Docker container"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access for package updates and dependency downloads
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
  }
}