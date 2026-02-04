resource "aws_s3_bucket" "beanstalk_deploys" {
  bucket = "${var.nome}-${var.ambiente}-${var.versao}-deploys-1233212"
}

resource "aws_s3_object" "docker" {
  depends_on = [aws_s3_bucket.beanstalk_deploys]
  bucket     = "${var.nome}-${var.ambiente}-${var.versao}-deploys-1233212"
  key        = "desenvolvimento.zip"
  source     = "desenvolvimento.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("desenvolvimento.zip")
}
