#----ancillary/main.tf


resource "aws_cloudwatch_log_group" "caris-version" {
  name = "/ga_sb_${var.env}/ecs/caris-version"

  tags = {
    Environment = "poc"
    Application = "caris"
  }
}

resource "aws_cloudwatch_log_group" "startstopec2" {
  name = "/ga_sb_${var.env}/ecs/startstopec2"

  tags = {
    Environment = "poc"
    Application = "caris"
  }
}

resource "aws_cloudwatch_log_group" "step-functions" {
  name = "/ga_sb_${var.env}/ecs/steps"

  tags = {
    Environment = "poc"
    Application = "caris"
  }
}


resource "aws_cloudwatch_event_rule" "trigger-processing-pipeline" {
  name        = "ga_sb_${var.env}-trigger-processing-pipeline"
  description = "trigger-processing-pipeline on s3 event"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "bathymetry-survey-288871573946"
      ]
    }
  }
}
PATTERN
}

