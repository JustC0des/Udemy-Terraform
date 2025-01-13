// IAM Role
data "aws_s3_bucket" "default" {
  bucket = "test-udemy-12-11-2024"
}

# resource "aws_iam_role" "example_role" {
#   name               = "example-role"
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       }
#     }
#   ]
# }
# POLICY
# }

resource "aws_iam_role" "example_role" {
  name               = "example-role"
  assume_role_policy = templatefile("${path.module}/iam_role.tmpl.json", { service_name = "glue.amazonaws.com" })
}

# // IAM Policy
# resource "aws_iam_policy" "example_policy" {
#   name        = "example-policy"
#   description = "Eine Beispiel Policy"
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:ListBucket"
#       ],
#       "Resource": [
#         ${data.aws_s3_bucket.default.arn}
#       ]
#     }
#   ]
# }
# POLICY
# }

resource "aws_iam_policy" "example_policy" {
  name        = "example-policy"
  description = "Eine Beispiel Policy"
  policy      = data.template_file.iam_policy.rendered
}


data "template_file" "iam_policy" {
  template = file("${path.module}/iam_policy.tmpl.json")

  vars = {
    bucket_arn = data.aws_s3_bucket.default.arn
  }
}

output "test" {
  value = data.template_file.iam_policy.rendered
}