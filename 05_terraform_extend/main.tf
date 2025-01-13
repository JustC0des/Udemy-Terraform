resource "aws_instance" "example_instance" {
  ami           = "ami-0e54671bdf3c8ed8d"
  instance_type = "t2.micro"
  user_data     = file("${path.module}/example.sh")

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes = [
      "user_data",
      "tags"
    ]
    # replace_triggered_by = [ 
    #   "aws_instance.example_instance",
    #  ]
  }
}