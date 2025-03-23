terraform {
  backend "s3" {
    bucket         = "terraform-state-eu-central-1-682033475665"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locks"
  }
}
