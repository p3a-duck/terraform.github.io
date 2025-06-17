provider "aws" {
  region = "ap-southeast-1" # Please use the default region ID
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "querypie-kyj-apse1-tfstate"

}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
    bucket = aws_s3_bucket.tfstate.id
    versioning_configuration{
    status = "Enabled" # Prevent from deleting tfstate file
    }
   # depends_on = [aws_s3_bucket.tfstate]
}

/*
# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform_lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}*/
