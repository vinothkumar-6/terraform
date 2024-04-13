#gloabl variable
variable "environment" {
    default = "default"
}
#local variable
locals {
    iam_user_extension = "my_iam_user_abc"
}
resource "aws_iam_user" "my_iam_user"{
    name  = "${local.iam_user_extension}_${var.environment}"
}
