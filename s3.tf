# ALB Log
resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.project-name}-alb-log"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
}

# CodePipeline Artifact
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.project-name}-artifact"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}
