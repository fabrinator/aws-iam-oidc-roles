terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-frivas"
    key            = "aws/aws-iam-oidc-roles"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
    profile = "infra-shared"
  }
}
