resource "aws_s3_bucket" "my_s3_bucket"{
    bucket ="my-s3-bucket-vinothkumar-7"
    versioning {
        enabled = true
    }
}
resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user_vinoth"
}