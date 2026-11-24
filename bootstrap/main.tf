resource "aws_s3_bucket" "terraform_state" {
  #checkov:skip=CKV_AWS_144:Multi-region replication outside current single-region scope.
  #checkov:skip=CKV_AWS_18:Access logging deferred to operational readiness.
  #checkov:skip=CKV2_AWS_62:No event-driven consumers required for current architecture.
  #checkov:skip=CKV_AWS_145:SSE-S3 accepted for isolated Floci environment only.
  bucket        = "application-infrastructure-state"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name      = "application-infrastructure-state"
    Purpose   = "Terraform remote state"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  depends_on = [
    aws_s3_bucket_versioning.terraform_state
  ]

  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
