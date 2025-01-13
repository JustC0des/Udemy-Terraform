variable "bucket_names" {
  type = map(string)
  default = {
    "dev" = "s3.bucket-udemy-dev"
    "qas" = "s3.bucket-udemy-qas"
    "prd" = "s3.bucket-udemy-prd"
  }
}