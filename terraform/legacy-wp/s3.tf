resource "aws_s3_bucket" "backup_bucket" {
	bucket        = "legacy-wp-dev-backups-891612560987"
	force_destroy = false

	tags = {
		Name        = "legacy-wp-dev-backups"
		Project     = "legacy-wp"
		Environment = "dev"
		ManagedBy   = "terraform"
	}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_encryption" {
	bucket = aws_s3_bucket.backup_bucket.id

	rule {
		apply_server_side_encryption_by_default {
			sse_algorithm = "AES256"
		}
	}
}

resource "aws_s3_bucket_public_access_block" "backup_block" {
	bucket                  = aws_s3_bucket.backup_bucket.id
	block_public_acls       = true
	block_public_policy     = true
	ignore_public_acls      = true
	restrict_public_buckets = true
}

output "backup_bucket_name" {
	value       = aws_s3_bucket.backup_bucket.id
	description = "Name of the automated database backup S3 bucket"
}
