// terraform apply -var-file=secrets.tfvars -auto-approve
// terraform destroy -var-file=secrets.tfvars -auto-approve
// terraform init -var-file=secrets.tfvars
variable "aws_secret" {} //key
variable "aws_acces" {} //key

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0" # Зазначте актуальну версію плагіна
    }
  }
}

provider "aws" {
  access_key = var.aws_acces  //key
  secret_key = var.aws_secret //key
  region = "eu-north-1"
}

// AWS 1
resource "aws_iam_user" "BUBLIK" {
  name = "BUBLIK"
}

resource "aws_iam_user" "PONCHIK" {
  name = "PONCHIK"
}

resource "aws_iam_access_key" "keysss" {
  user = aws_iam_user.BUBLIK.name
}

resource "local_file" "variables_file" {
  content  = <<-EOF
    aws_acces = "${aws_iam_access_key.keysss.id}"
    aws_secret = "${aws_iam_access_key.keysss.secret}"
    EOF

  filename = "${path.module}/machine/secrets.tfvars"
}

resource "aws_iam_group_membership" "my_membership" {
  name = "TESTIK"
  users = [ aws_iam_user.BUBLIK.name ]
  group = aws_iam_group.test1.name
}

resource "aws_iam_group" "test1" {
  name = "BUBLIK-GROUPS"
}

resource "aws_iam_policy" "qwerty" {
  name = "TERR-EC2"
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
})
}

resource "aws_iam_group_policy_attachment" "my_attach" {
  group = aws_iam_group.test1.name
  policy_arn = aws_iam_policy.qwerty.arn
}


