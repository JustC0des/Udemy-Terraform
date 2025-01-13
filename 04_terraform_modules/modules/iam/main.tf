resource "aws_iam_instance_profile" "example" {
  name = "example-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2-role"
  description        = "Role for ec2 instance"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "${var.service}.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_role" {
  name        = "ec2-policy"
  description = "My test policy for ec2"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement" : [
    {
      "Action": "${var.service}:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_role.arn
}
