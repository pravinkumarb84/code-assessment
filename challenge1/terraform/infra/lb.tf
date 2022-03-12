resource "aws_lb" "code_assessment_lb" {
  name                       = "code-assessment-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg.id]
  subnets                    = aws_subnet.public.*.id
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.code-assessment-lb-logs.bucket
    prefix  = "code-assessment-lb-logs"
    enabled = true
  }

  tags = {
    Name        = "code-assessment-lb"
    Owner       = "code-assessment"
    Environment = "assessment"
    Igw_Name    = aws_internet_gateway.code-assessment-igw.id
  }
  depends_on = [
    aws_s3_bucket_policy.lb_s3_policy
  ]
}

resource "aws_alb_listener" "code_assessment_listener" {
  load_balancer_arn = aws_lb.code_assessment_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.code_assessment_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "code_assessment_tg" {
  name     = "code-assessment-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_assessment.id
  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_s3_bucket" "code-assessment-lb-logs" {
  bucket        = "code-assessment-lb-bucket"
  force_destroy = true


  tags = {
    Name        = "code-assessment-lb-logs-bucket"
    Owner       = "code-assessment"
    Environment = "assessment"
  }
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "lb_s3_policy" {
  bucket = aws_s3_bucket.code-assessment-lb-logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "lb_s3_policy"
    Statement = [
      {
        Sid    = "S3_lb_access_1"
        Effect = "Allow"
        Principal = {
          "AWS" : [
            data.aws_elb_service_account.main.arn
          ]
        }
        Action = "s3:PutObject"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.code-assessment-lb-logs.bucket}/code-assessment-lb-logs/AWSLogs/${local.account_id}/*",
        ]
      },
      {
        Sid    = "S3_lb_access_2"
        Effect = "Allow"
        Principal = {
          "Service" : [
            "delivery.logs.amazonaws.com",
          ]
        }
        Action = "s3:GetBucketAcl"
        Resource = [
          "arn:aws:s3:::code-assessment-lb-bucket",
        ]
      },
      {
        Sid    = "S3_lb_access_3"
        Effect = "Allow"
        Principal = {
          "Service" : [
            "delivery.logs.amazonaws.com",
          ]
        }
        Action = "s3:PutObject"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.code-assessment-lb-logs.bucket}/code-assessment-lb-logs/AWSLogs/${local.account_id}/*",
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

