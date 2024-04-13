variable "users" {
  default = {
    ravs : { country : "Netherlands", department : "BDA" },
    tom : { country : "US", department : "BDSA" },
    jane : { country : "India", department : "BSDVDA" }
  }
}

resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }
}