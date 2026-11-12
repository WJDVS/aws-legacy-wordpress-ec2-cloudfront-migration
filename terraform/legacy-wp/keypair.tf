resource "aws_key_pair" "wp_key" {
  key_name   = "${var.project_name}-${var.environment}-keypair"
  public_key = file("~/.ssh/legacy-wp-dev-key.pub")

  tags = {
    Name = "${var.project_name}-${var.environment}-keypair"
  }
}
