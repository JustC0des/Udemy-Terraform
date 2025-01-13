## Das ist eine Testdatei für den ersten Commit in Githu

terraform {
  backend "s3" {
    bucket = "test-udemy-12-11-2024"
    key    = "terraform_state/state_workspace"
    region = "eu-central-1"
  }
}

resource "aws_s3_bucket" "udemy" {
  bucket = "s3.bucket-udemy-${terraform.workspace}"
}
