## cloudflare top level domain.

resource "cloudflare_record" "aws_ns" {
  zone_id = data.cloudflare_zones.master.zones.0.id
  name    = var.cf_subdomain
  value   = aws_s3_bucket.antistatic.website_endpoint
  type    = "CNAME"
  proxied = true
}

data "cloudflare_zones" "master" {
  filter {
    name   = var.cf_zone
    status = "active"
    paused = false
  }
}

resource "aws_s3_bucket" "antistatic" {
  bucket        = "${var.cf_subdomain}.${var.cf_zone}"
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket       = aws_s3_bucket.antistatic.id
  key          = "index.html"
  content_type = "text/html"
  source       = "../src/index.html"
  acl          = "public-read"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../src/index.html")
}
