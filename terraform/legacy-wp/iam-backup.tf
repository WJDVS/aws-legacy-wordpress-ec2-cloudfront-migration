# iam-backup.tf — lets the EC2 instance list, upload and download backups in its S3 bucket only

data "aws_iam_policy_document" "wp_backup_s3" {
  statement {
    sid       = "ListBackupBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.backup_bucket.arn]
  }

  statement {
    sid       = "ReadWriteBackupObjects"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${aws_s3_bucket.backup_bucket.arn}/*"]
  }
}

resource "aws_iam_role_policy" "wp_backup_s3" {
  name   = "legacy-wp-dev-backup-s3"
  role   = aws_iam_role.wp_ssm_role.name
  policy = data.aws_iam_policy_document.wp_backup_s3.json
}