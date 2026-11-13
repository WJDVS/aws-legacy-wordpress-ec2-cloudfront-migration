resource "aws_iam_role" "wp_ssm_role" {
  name = "legacy-wp-dev-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "legacy-wp-dev-ssm-role"
    Project     = "legacy-wp"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "wp_ssm_core" {
  role       = aws_iam_role.wp_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "wp_ssm_profile" {
  name = "legacy-wp-dev-ssm-profile"
  role = aws_iam_role.wp_ssm_role.name
}