#terraform-state-file-in-s3-with-DynamoDB-lockfile-enabled

aws s3 mb s3://my-terraform-state-bucket
aws dynamodb create-table \
  --table-name my-terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# then add this to config file of terraform
backend "s3" {
  bucket = "my-terraform-state-bucket"
  key = "terraform.tfstate"
  dynamodb_table = "my-terraform-state-lock"
}

#DONE
# If you already have an statefile in local you can import it
terraform state import s3://my-terraform-state-bucket/terraform.tfstate

# real world example file:
terraform {

  backend "s3" {
  bucket = "opendress-cloud-iac"
  key = "API-v3/terraform.tfstate"
  dynamodb_table = "terraform-statefile-vpc-apiv3"
  region = "eu-central-1"
  encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  }

  provider "aws" {
    region = "eu-central-1"
  }
  
