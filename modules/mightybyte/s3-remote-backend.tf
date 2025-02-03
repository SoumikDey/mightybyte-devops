module "s3-remote-backend" {
  source = "../s3-bucket"
  bucket = "${var.resource_tags["environ"]}-remote-backend"
  versioning = {
    enabled = true
  }
  block_public_acls        = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
  block_public_policy      = true
  attach_policy            = false
  policy                   = ""
  control_object_ownership = false
  object_ownership         = "BucketOwnerEnforced"
  tags                     = var.resource_tags

}