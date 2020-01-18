provider "aws" {
  region = "eu-west-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

terraform {
  backend "s3" {
  }
}
