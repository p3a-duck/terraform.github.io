#create querypie_db_sync role
resource "aws_iam_role" "querypie_sync" {
  name               = "querypie_db_sync_role"
  path               = "/"
  description = "Do not delete. This resource was created by Terraform. Created by Yujoong Kim."
  assume_role_policy = jsonencode ({

  Version =  "2012-10-17",
  Statement= [
    {
      Sid =  "",
      Effect = "Allow",
      Principal = {
        Service =  "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }
  ]
})
}


#create ssm_core role
resource "aws_iam_role" "ssm_core" {
  name               = "ssm_core"
  path               = "/"
  description = "Do not delete. This resource was created by Terraform. Created by Yujoong Kim."
  assume_role_policy = jsonencode ({

  Version = "2012-10-17",
  Statement = [
    {
      Sid = "",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }
  ]
})
}

#attach iam role (rds/s3/dynamo/ssm)
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

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role   = aws_iam_role.ssm_core.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#ssm Instance Profile
resource "aws_iam_instance_profile" "bst_profile" {
  name = "bastion_ssm_instance_profile"
  role = aws_iam_role.ssm_core.name
}

#querypie Instance Profile
resource "aws_iam_instance_profile" "qp_profile" {
  name = "querypie_ssm_instance_profile"
  role = aws_iam_role.querypie_sync.name
}
