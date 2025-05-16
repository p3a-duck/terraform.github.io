terraform {
    backend "s3" {   
      bucket         = "querypie-kyj-apse1-tfstate"  
      key            = "terraform/QueryPie/vpc/terraform.tfstate" 
      region         = "ap-southeast-1"  
      encrypt        = true
      dynamodb_table = "terraform_lock"
    }
}
