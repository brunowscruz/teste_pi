provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws"
  version       = "2.6.1"
  handler       = "some-handler"
  function_name = "handler"
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"

  // configurable event trigger
  event {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
  }

  environment {
    variables {
      loglevel = "INFO"
    }
  }

  // optionally enable VPC access
  vpc_config {
    security_group_ids = ["sg-1"]
    subnet_ids         = ["subnet-1", "subnet-2"]
  }
}
