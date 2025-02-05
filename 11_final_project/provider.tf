terraform {
  backend "s3" {
    bucket         = "udemy-final-project"
    key            = "terraform_state/state_locked"
    region         = "eu-central-1"
    use_lockfile = true
    encrypt        = true
  }
}