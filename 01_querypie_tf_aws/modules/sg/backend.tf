terraform {
    backend "s3" {
      bucket         = "querypie-kyj-apse1-tfstate"
      key            = "02_terraform/01_querypie_tf_aws/modules/sg/terraform.tfstate"
      region         = "ap-southeast-1"  
      encrypt        = true
      dynamodb_table = "terraform_lock"
    }
}
