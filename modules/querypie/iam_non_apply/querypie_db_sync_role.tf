resource "aws_iam_role" "querypie_sync" {
  name               = "querypie_db_sync_role"
  path               = "/"
  description = "Do not delete. This resource was created by Terraform. Created by Yujoong Kim."
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "db_sync_rds" {
  role   = aws_iam_role.querypie_sync.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"

}

resource "aws_iam_role_policy_attachment" "db_sync_s3" {
  role   = aws_iam_role.querypie_sync.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

}

resource "aws_iam_role_policy_attachment" "db_sync_dynamo" {
  role   = aws_iam_role.querypie_sync.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"

}

