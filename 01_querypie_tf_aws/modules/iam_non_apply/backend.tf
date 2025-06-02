terraform {
    backend "s3" { # 강의는 
      bucket         = "querypie-kyj-apse1-tfstate" # s3 bucket 이름
      key            = "terraform/QueryPie/iam/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
      region         = "ap-southeast-1"  
      encrypt        = true
      dynamodb_table = "terraform_lock"
    }
}
