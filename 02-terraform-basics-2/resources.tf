variable "iam_user_name_prefix" {
  default = "my_iam_user_vinoth"
}

resource "aws_iam_user" "my_iam_user" {
  count = 1
  name  = "${var.iam_user_name_prefix}_${count.index}"
}