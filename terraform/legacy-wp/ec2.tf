# Fetch latest official Ubuntu 22.04 LTS AMI in us-east-1
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Provision EC2 Instance for Legacy WordPress
resource "aws_instance" "wp_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.wp_key.key_name
  vpc_security_group_ids = [aws_security_group.wp_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.wp_ssm_profile.name # SSM Session Manager access

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }

  lifecycle {
    # Canonical publishes new AMIs regularly; without this, a newer AMI would force a server replacement
    ignore_changes  = [ami]
    prevent_destroy = true
  }
}

output "ec2_public_ip" {
  value       = aws_instance.wp_server.public_ip
  description = "Public IP address of the legacy WordPress EC2 instance"
}

output "ec2_instance_id" {
  value       = aws_instance.wp_server.id
  description = "Instance ID used for SSM Session Manager (aws ssm start-session --target <id>)"
}